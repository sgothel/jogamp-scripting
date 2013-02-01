set J2RE_HOME=c:\jre1.6.0_35_x64
set JAVA_HOME=c:\jdk1.6.0_35_x64
set ANT_PATH=C:\apache-ant-1.8.2
set GIT_PATH=C:\cygwin\bin
set SEVENZIP=C:\Program Files\7-Zip

set CMAKE_PATH=C:\cmake-2.8.10.2-win32-x86
set CMAKE_C_COMPILER=c:\mingw64\bin\gcc

set PATH=%JAVA_HOME%\bin;%ANT_PATH%\bin;c:\mingw64\bin;%CMAKE_PATH%\bin;%GIT_PATH%;%SEVENZIP%;%PATH%

REM    -Dc.compiler.debug=true 
REM    -DuseOpenMAX=true 
REM    -DuseKD=true
REM    -Djogl.cg=1 -D-Dwindows.cg.lib=C:\Cg-2.2
REM    -Dbuild.noarchives=true

java -server -Xmx1024m -jar slave.jar -jnlpUrl https://jogamp.org/chuck/computer/win64-nvgtx460-win7-jogamp-x64-sgothel-011/slave-agent.jnlp
