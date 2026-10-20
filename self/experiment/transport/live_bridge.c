/* SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque
 * Loopback-only display transport. Self renders; this server only sends
 * fresh JPEG frames and writes constant, allowlisted commands to its FIFO.
 */
#define _POSIX_C_SOURCE 200809L
#include <arpa/inet.h>
#include <errno.h>
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <time.h>
#include <unistd.h>

static char frame_path[1024], fifo_path[1024], token[33];
static pthread_mutex_t lock = PTHREAD_MUTEX_INITIALIZER;
static unsigned clients;
static double last_action;
static const struct { const char *name, *label, *command; } actions[] = {
 {"efficiency", "Efficiency", "lrdWorkspace view model cycleEpsilon."},
 {"duty", "Duty cycle", "lrdWorkspace view model cycleDuty."},
 {"lambda", "Luminosity ratio", "lrdWorkspace view model cycleLambda."},
 {"formation", "Formation z", "lrdWorkspace view model cycleFormation."},
 {"model", "Growth model", "lrdWorkspace view model toggleModel."},
 {"theta", "Polar angle", "lrdWorkspace view model cycleTheta."},
 {"phase", "Phase", "lrdWorkspace view model cyclePhase."},
 {"play", "Play / pause", "lrdWorkspace view playing: lrdWorkspace view playing not."},
 {"reset", "Reset", "lrdWorkspace view model reset. lrdWorkspace view tick: 0."}
};
static double now(void) {
 struct timespec t; clock_gettime(CLOCK_MONOTONIC, &t);
 return (double)t.tv_sec + (double)t.tv_nsec / 1e9;
}
static int send_all(int fd, const void *data, size_t length) {
 const char *p = data;
 while (length) { ssize_t n = send(fd, p, length, MSG_NOSIGNAL);
  if (n < 0 && errno == EINTR) continue;
  if (n <= 0) return -1;
  p += n; length -= (size_t)n;
 } return 0;
}
static void response(int fd, int code, const char *type, const char *body) {
 char header[1600]; size_t n = strlen(body);
 snprintf(header, sizeof header,
  "HTTP/1.1 %d Result\r\nContent-Type: %s\r\nContent-Length: %zu\r\n"
  "Cache-Control: no-store\r\nX-Content-Type-Options: nosniff\r\n"
  "Content-Security-Policy: default-src 'none'; img-src 'self'; form-action 'self'; "
  "frame-src 'self'; frame-ancestors 'self' https://ahmadaliparr.github.io; base-uri 'none'\r\n"
  "Connection: close\r\n\r\n", code, type, n);
 send_all(fd, header, strlen(header)); send_all(fd, body, n);
}
static int fresh(void) {
 struct stat s;
 return stat(frame_path, &s) == 0 && s.st_size > 4 && time(NULL) - s.st_mtime <= 5;
}
static void live_page(int fd) {
 char page[10000]; size_t n = (size_t)snprintf(page, sizeof page,
  "<!doctype html><html lang=en><meta charset=utf-8><meta name=viewport content='width=device-width,initial-scale=1'>"
  "<title>Live Self / Morphic - JWST LRD</title><body bgcolor='#060a12' text='#e4edf6'>"
  "<h2>Live Self / Morphic</h2><p>Native frames from the running Self VM. Controls update that process. "
  "Archived spectrum is observational data; helix, nucleus and phase wave are model visualizations.</p>"
  "<form method=post action='/action' target=command-result><input type=hidden name=token value='%s'>", token);
 for (size_t i = 0; i < sizeof actions / sizeof actions[0]; ++i)
  n += (size_t)snprintf(page+n, sizeof(page)-n,
   "<button type=submit name=action value='%s'>%s</button> ", actions[i].name, actions[i].label);
 snprintf(page+n, sizeof(page)-n,
  "</form><iframe name=command-result title='Control acknowledgement' hidden></iframe>"
  "<p><img src='/stream.mjpg' width='100%%' alt='Live native Self display; if disconnected, reload this route.'></p>"
  "<p>No remote shell, desktop control, file upload or arbitrary code execution is exposed.</p></body></html>");
 response(fd, 200, "text/html; charset=utf-8", page);
}
static void stream(int fd) {
 const char header[] = "HTTP/1.1 200 OK\r\nContent-Type: multipart/x-mixed-replace; boundary=self-frame\r\n"
  "Cache-Control: no-store\r\nX-Content-Type-Options: nosniff\r\nConnection: close\r\n\r\n";
 if (send_all(fd, header, sizeof(header)-1)) return;
 double end = now() + 3600.0;
 while (now() < end && fresh()) {
  FILE *f = fopen(frame_path, "rb");
  if (!f) break;
  struct stat s;
  if (fstat(fileno(f), &s) || s.st_size < 4 || s.st_size > 3000000) { fclose(f); break; }
  size_t length = (size_t)s.st_size;
  unsigned char *data = malloc(length);
  if (!data) { fclose(f); break; }
  size_t got = fread(data, 1, length, f); fclose(f);
  if (got != length || data[0] != 0xff || data[1] != 0xd8 ||
      data[length-2] != 0xff || data[length-1] != 0xd9) { free(data); break; }
  char boundary[160];
  snprintf(boundary, sizeof boundary, "--self-frame\r\nContent-Type: image/jpeg\r\nContent-Length: %zu\r\n\r\n", length);
  int failed = send_all(fd, boundary, strlen(boundary)) || send_all(fd, data, length) || send_all(fd, "\r\n", 2);
  free(data); if (failed) break;
  struct timespec pause = {0, 125000000}; nanosleep(&pause, NULL);
 }
}
static void action(int fd, const char *body) {
 char expected[180];
 for (size_t i = 0; i < sizeof actions / sizeof actions[0]; ++i) {
  snprintf(expected, sizeof expected, "token=%s&action=%s", token, actions[i].name);
  if (strcmp(body, expected)) continue;
  pthread_mutex_lock(&lock);
  if (now() - last_action < 0.15) {
   pthread_mutex_unlock(&lock); response(fd, 429, "text/plain", "Please wait briefly.\n"); return;
  }
  if (!fresh()) { pthread_mutex_unlock(&lock); response(fd, 503, "text/plain", "Renderer offline.\n"); return; }
  int fifo = open(fifo_path, O_WRONLY | O_NONBLOCK);
  char command[512];
  int length = snprintf(command, sizeof command, "%s lrdWorkspace view changed.\n", actions[i].command);
  ssize_t sent = fifo < 0 ? -1 : write(fifo, command, (size_t)length);
  if (fifo >= 0) close(fifo);
  last_action = now(); pthread_mutex_unlock(&lock);
  response(fd, sent == length ? 204 : 503, "text/plain", ""); return;
 }
 response(fd, 403, "text/plain", "Invalid action or session token.\n");
}
static void *client(void *argument) {
 int fd = *(int *)argument; free(argument);
 struct timeval timeout = {5, 0};
 setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof timeout);
 setsockopt(fd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof timeout);
 char request[8192]; size_t used = 0; char *body = NULL;
 while (used < sizeof(request)-1) {
  ssize_t count = recv(fd, request+used, sizeof(request)-1-used, 0);
  if (count <= 0) goto finish;
  used += (size_t)count; request[used] = 0;
  body = strstr(request, "\r\n\r\n"); if (body) { body += 4; break; }
 }
 if (!body) { response(fd, 431, "text/plain", "Request too large.\n"); goto finish; }
 char method[8], path[128];
 if (sscanf(request, "%7s %127s", method, path) != 2) goto finish;
 if (!strcmp(method, "GET") && (!strcmp(path, "/") || !strcmp(path, "/live/"))) live_page(fd);
 else if (!strcmp(method, "GET") && !strcmp(path, "/health"))
  response(fd, fresh() ? 200 : 503, "application/json", fresh() ? "{\"renderer\":\"Self/Morphic\",\"fresh\":true}\n" : "{\"fresh\":false}\n");
 else if (!strcmp(method, "GET") && !strcmp(path, "/stream.mjpg")) {
  if (!fresh()) response(fd, 503, "text/plain", "Renderer offline.\n"); else stream(fd);
 } else if (!strcmp(method, "POST") && !strcmp(path, "/action")) {
  char *h = strstr(request, "\r\nContent-Length:");
  if (!h) h = strstr(request, "\r\ncontent-length:");
  unsigned long length = h ? strtoul(h+17, NULL, 10) : 1000;
  size_t offset = (size_t)(body-request);
  if (length > 128) { response(fd, 413, "text/plain", "Action too large.\n"); goto finish; }
  while (used-offset < length) {
   ssize_t count = recv(fd, request+used, offset+length-used, 0);
   if (count <= 0) goto finish;
   used += (size_t)count;
  }
  body[length] = 0; action(fd, body);
 } else response(fd, 404, "text/plain", "Not found.\n");
finish:
 close(fd); pthread_mutex_lock(&lock); --clients; pthread_mutex_unlock(&lock); return NULL;
}
int main(int argc, char **argv) {
 if (argc != 3 || strlen(argv[1]) >= sizeof frame_path || strlen(argv[2]) >= sizeof fifo_path) {
  fprintf(stderr, "usage: live_bridge FRAME_JPEG SELF_FIFO\n"); return 2;
 }
 strcpy(frame_path, argv[1]); strcpy(fifo_path, argv[2]); signal(SIGPIPE, SIG_IGN);
 unsigned char random[16]; int source = open("/dev/urandom", O_RDONLY);
 if (source < 0 || read(source, random, sizeof random) != sizeof random) return 2;
 close(source); for (size_t i=0; i<sizeof random; ++i) snprintf(token+i*2, 3, "%02x", random[i]);
 int server = socket(AF_INET, SOCK_STREAM, 0), yes = 1;
 setsockopt(server, SOL_SOCKET, SO_REUSEADDR, &yes, sizeof yes);
 struct sockaddr_in address = {.sin_family=AF_INET, .sin_port=htons(8765), .sin_addr.s_addr=htonl(INADDR_LOOPBACK)};
 if (server < 0 || bind(server, (void *)&address, sizeof address) || listen(server, 16)) { perror("listen"); return 2; }
 puts("Self display transport listening on 127.0.0.1:8765"); fflush(stdout);
 for (;;) {
  int fd = accept(server, NULL, NULL); if (fd < 0) continue;
  pthread_mutex_lock(&lock);
  if (clients >= 16) { pthread_mutex_unlock(&lock); close(fd); continue; }
  ++clients; pthread_mutex_unlock(&lock);
  int *argument = malloc(sizeof *argument);
  if (!argument) { close(fd); pthread_mutex_lock(&lock); --clients; pthread_mutex_unlock(&lock); continue; }
  *argument = fd; pthread_t thread;
  if (pthread_create(&thread, NULL, client, argument)) {
   free(argument); close(fd); pthread_mutex_lock(&lock); --clients; pthread_mutex_unlock(&lock);
  } else pthread_detach(thread);
 }
}
