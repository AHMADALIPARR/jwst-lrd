/* SPDX-License-Identifier: AGPL-3.0-only AND LicenseRef-SnapKitty-Opaque */
/* Independent analytic clock and RK4 check against the committed Fortran grid.
 * No observational fitting: mass and cosmology are declared benchmark inputs. */
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static const double target = 5e7, om = .3153, ol = .6847;
static double tedd(void) {
    return 6.6524587321e-29 * 299792458.0 /
        (4 * acos(-1.) * 6.67430e-11 * 1.67262192369e-27) / (31557600.0 * 1e9);
}
static double age(double z) {
    return 2 / (3 * sqrt(ol)) * asinh(sqrt(ol / om) * pow(1+z, -1.5)) *
        (3.0856775814913673e19 / 67.36 / (31557600.0 * 1e9));
}
static double effective(double lam, int sat) { return sat && lam > 1 ? 1+log(lam) : lam; }
static double rate(double eps, double duty, double lam, int sat) {
    return duty * (1-eps) / eps * effective(lam, sat) / tedd();
}
static double seedmin(double eps, double duty, double lam, double z, int sat) {
    return target * exp(-rate(eps,duty,lam,sat) * (age(7.04221)-age(z)));
}
static void require(int ok, const char *name) {
    printf("%s %s\n", ok ? "PASS" : "FAIL", name);
    if (!ok) exit(1);
}
static void svg(FILE *f, double dt) {
    const char *colors[] = {"#ff7777", "#57d6ff", "#8eefb0"};
    double seeds[] = {100, 1000, 100000};
    fprintf(f, "<svg xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"0 0 1200 760\" role=\"img\"><title>QSO1 growth constraints computed from declared inputs</title><rect width=\"1200\" height=\"760\" fill=\"#09111f\"/><g font-family=\"sans-serif\" fill=\"#edf3ff\"><text x=\"50\" y=\"48\" font-size=\"28\">QSO1: WHICH SEEDS REACH THE BENCHMARK?</text><text x=\"50\" y=\"80\" font-size=\"17\">Target 50 million solar masses | efficiency 0.1 | duty 1 | formation z=20</text>");
    for (int k=0;k<=8;k++) {
        double y=590-k*52;
        fprintf(f,"<path d=\"M90 %.1fH1110\" stroke=\"#26364c\"/><text x=\"35\" y=\"%.1f\" font-size=\"15\">10^%d</text>",y,y+5,k+2);
    }
    fprintf(f,"<path d=\"M90 %.2fH1110\" stroke=\"white\" stroke-dasharray=\"8 6\"/><text x=\"690\" y=\"%.2f\" font-size=\"16\">50 million target</text>",590-(log10(target)-2)*52,578-(log10(target)-2)*52);
    for(int j=0;j<3;j++) {
        fprintf(f,"<polyline fill=\"none\" stroke=\"%s\" stroke-width=\"3\" points=\"",colors[j]);
        for(int i=0;i<=240;i++) {
            double elapsed=dt*i/240, mass=seeds[j]*exp(rate(.1,1,1,0)*elapsed);
            double y=590-(log10(mass)-2)*52;
            if(y>=125 && y<=590) fprintf(f,"%.2f,%.2f ",90+1020.*i/240,y);
        }
        fprintf(f,"\"/><text x=\"%.1f\" y=\"%.1f\" fill=\"%s\" font-size=\"16\">seed %.0f: final %.3g</text>",120.+j*330.,625.,colors[j],seeds[j],seeds[j]*exp(rate(.1,1,1,0)*dt));
    }
    fprintf(f,"<text x=\"90\" y=\"115\" font-size=\"15\">Mass [solar masses, logarithmic]</text><text x=\"90\" y=\"610\" font-size=\"14\">formation</text><text x=\"890\" y=\"610\" font-size=\"14\">observation: %.2f Myr later</text><text x=\"50\" y=\"675\" font-size=\"20\">RESULT: 100-solar-mass seed fails at lambda=1; minimum seed %.2f.</text><text x=\"50\" y=\"706\" font-size=\"17\">But a higher rate rescues it. Growth alone does not uniquely select a formation mechanism.</text><text x=\"50\" y=\"735\" font-size=\"14\">Model calculation, not a reconstructed dynamical mass or observed growth history. I = ln(M/Mseed) - rate*t = 0.</text></g></svg>\n",dt*1000,seedmin(.1,1,1,20,0));
}
int main(int argc, char **argv) {
    if(argc!=4) { fprintf(stderr,"usage: growth_result grid.csv result.txt result.svg\n"); return 2; }
    FILE *in=fopen(argv[1],"r");
    if(!in) { perror(argv[1]); return 2; }
    char line[2048];
    if(!fgets(line,sizeof line,in) || strncmp(line,"lam,eps,z_form,duty,",19)) return 2;
    int rows=0, changed=0; double worst=0, dt=age(7.04221)-age(20);
    while(fgets(line,sizeof line,in)) {
        double l,e,z,d,tm,md,g,gs,s,ss; int a,b;
        if(sscanf(line,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%d,%d",&l,&e,&z,&d,&tm,&md,&g,&gs,&s,&ss,&a,&b)!=12) return 2;
        if(!isfinite(s)||!isfinite(ss)||s<=0||ss<=0||!isfinite(l)||!isfinite(e)||
           !isfinite(z)||!isfinite(d)||e<=0||e>=1||d<=0||d>1||l<=0||z<=7.04221 ||
           !isfinite(tm)||!isfinite(md)||!isfinite(g)||!isfinite(gs)||g<=0||gs<=0) return 1;
        double simple=seedmin(e,d,l,z,0), sat=seedmin(e,d,l,z,1);
        double err=fmax(fabs(simple/s-1),fabs(sat/ss-1)); worst=fmax(worst,err);
        if(err>2e-7 || fabs(tm/1000/(age(7.04221)-age(z))-1)>2e-8 ||
           fabs(md-l/e)>1e-5 || fabs(g*s/target-1)>2e-8 || fabs(gs*ss/target-1)>2e-8) return 1;
        if(l<=1 && fabs(s/ss-1)>1e-9) return 1;
        if(ss<s*(1-1e-9)) return 1;
        if(a!=b) changed++;
        rows++;
    }
    fclose(in);
    require(rows==1200,"analytic_clock_reproduces_all_1200_fortran_rows");
    require(changed==82,"saturation_changes_82_grid_feasibility_labels");
    double r=rate(.1,1,1,0), m=100, residual=0, h=dt/2000;
    for(int i=1;i<=2000;i++) {
        double k1=r*m,k2=r*(m+h*k1/2),k3=r*(m+h*k2/2),k4=r*(m+h*k3);
        m+=h*(k1+2*k2+2*k3+k4)/6;
        residual=fmax(residual,fabs(log(m/100)-r*h*i));
    }
    require(residual<1e-9,"rk4_log_growth_invariant_all_2000_steps");
    double needed=log(target/100)/r/dt;
    double satneeded=exp(needed-1);
    require(m<target && 1000*exp(r*dt)>target,"benchmark_excludes_100_accepts_1000");
    require(fabs(100*exp(rate(.1,1,needed,0)*dt)/target-1)<1e-12,"simple_rate_counterexample_hits_target");
    require(fabs(100*exp(rate(.1,1,satneeded,1)*dt)/target-1)<1e-12,"saturated_rate_counterexample_hits_target");
    require(fabs(rate(.1,.5,2,0)-r)<1e-12,"duty_lambda_degeneracy_same_history");
    require(fabs(rate(.1,.5,exp(1),1)-r)<1e-12,"saturated_duty_lambda_degeneracy");
    require(fabs(seedmin(.1,.25,1,20,0)/seedmin(.1,.5,1,20,0)-exp(r*dt*.25))<1e-6,"reduced_duty_increases_required_seed");
    FILE *out=fopen(argv[2],"w"); if(!out) return 2;
    fprintf(out,"QSO1 COMPUTED GROWTH CONSTRAINTS\nDeclared benchmark: Mtarget=5e7 Msun; zobs=7.04221; zform=20; epsilon=0.1; duty=1; lambda=1.\nFlat matter+Lambda cosmology H0=67.36, Om=.3153, Ol=.6847; radiation neglected.\nAvailable growth time: %.9f Myr\nEddington time: %.9f Myr\nGrowth exponent: %.12f\nMinimum seed (continuous numerical model): %.9f Msun\n100 Msun seed final mass: %.9f Msun (EXCLUDED for benchmark tuple)\n1000 Msun seed final mass: %.9f Msun (REACHES target)\n100 Msun seed required lambda, simple: %.12f\n100 Msun seed required lambda, saturation prescription: %.12f\nMinimum seed at duty .5: %.9f Msun\nMinimum seed at duty .25: %.9f Msun\nMax log-growth invariant residual over 2000 RK4 steps: %.12g\nIndependent analytic-clock comparison: %d rows; max relative seed difference %.12g\nGrid feasibility labels changed by saturation: %d (grid counts are not probabilities).\nCONCLUSION: a 100 Msun seed fails under the benchmark Eddington tuple, but reaches the same target at the computed higher rate. These constraints do not uniquely require heavy-seed or primordial formation.\nAgda: Growth.grow-no-loss, grow-compose, factor-mono, sufficient and Benchmark.cert prove rational model statements. The separate 9000 Msun certificate is conservative and its continuous interpretation requires A-GR-1.\nThe numerical 502-ish threshold above is NOT an Agda-certified floating-point error interval.\nNo dynamical-mass fit, uncertainty inference, gas-supply bound or likelihood comparison is performed.\n",dt*1000,tedd()*1000,r*dt,seedmin(.1,1,1,20,0),m,1000*exp(r*dt),needed,satneeded,seedmin(.1,.5,1,20,0),seedmin(.1,.25,1,20,0),residual,rows,worst,changed);
    if(fclose(out)) return 2;
    out=fopen(argv[3],"w"); if(!out) return 2; svg(out,dt); if(fclose(out)) return 2;
    return 0;
}
