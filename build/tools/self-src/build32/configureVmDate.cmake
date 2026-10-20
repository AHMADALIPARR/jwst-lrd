# configured variables 
set(WIN32 ) 
set(UNIX 1) 
set(PLATFORM "Linux i386")
set(GIT_DIR "/home/hatch/workspace/jwst-lrd/build/tools/self-src/vm/..")
set(IN_FILE "/home/hatch/workspace/jwst-lrd/build/tools/self-src/vm/build_support/vmDate.cpp.in") 
set(OUT_FILE "/home/hatch/workspace/jwst-lrd/build/tools/self-src/build32/incls/vmDate.cpp") 

# make sure we don't get translated messages 
set(ENV{LC_ALL} C) 

# determine date 
if(WIN32) 
  execute_process(COMMAND cmd /c "date /T"
    RESULT_VARIABLE getdate_result 
    OUTPUT_VARIABLE D 
    ERROR_VARIABLE D 
    OUTPUT_STRIP_TRAILING_WHITESPACE) 
  execute_process(COMMAND cmd /c "time /T"
    RESULT_VARIABLE getdate_result 
    OUTPUT_VARIABLE D 
    ERROR_VARIABLE D 
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  set(DATE "${D} ${T}")
elseif(UNIX) 
  execute_process(COMMAND date "+%a\ %d\ %h\ %y\ %H:%M:%S" 
    RESULT_VARIABLE getdate_result 
    OUTPUT_VARIABLE DATE 
    ERROR_VARIABLE DATE 
    OUTPUT_STRIP_TRAILING_WHITESPACE) 
else() 
  message(FATAL_ERROR "Can't determine date on this system.") 
endif() 

if(getdate_result) 
  message(FATAL_ERROR "Failed to determine date:\n${DATE}") 
endif() 

# determine git revision 
execute_process(COMMAND git --version 
  RESULT_VARIABLE _git_not_there
  OUTPUT_VARIABLE _
  ERROR_VARIABLE _) 
if(_git_not_there)
  set(GIT_REVISION "")
else()
  execute_process(COMMAND git describe --tags --dirty
    WORKING_DIRECTORY "${GIT_DIR}"
    RESULT_VARIABLE git_result
    OUTPUT_VARIABLE GIT_REVISION 
    ERROR_VARIABLE GIT_REVISION 
    OUTPUT_STRIP_TRAILING_WHITESPACE) 
  set(GIT_REVISION " (${GIT_REVISION})")
  if(git_result) 
    message(FATAL_ERROR "Failed to determine git revision:\n${GIT_REVISION}") 
  endif() 
endif()

#set is:
# DATE
# PLATFORM
# GIT_REVISION

configure_file("${IN_FILE}" "${OUT_FILE}") 
