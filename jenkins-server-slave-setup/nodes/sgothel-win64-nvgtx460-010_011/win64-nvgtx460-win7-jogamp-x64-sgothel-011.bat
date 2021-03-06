set J2RE_HOME=c:\jre-11.0.4+11_x64
set JAVA_HOME=c:\jdk-11.0.4+11_x64
set ANT_PATH=C:\apache-ant-1.10.5
set GIT_PATH=C:\cygwin64\bin
set SEVENZIP=C:\Program Files\7-Zip

set CMAKE_PATH=C:\cmake-3.15.2-win64-x64
set CMAKE_C_COMPILER=c:\mingw64\bin\gcc

set PATH=%J2RE_HOME%\bin;%JAVA_HOME%\bin;%ANT_PATH%\bin;c:\mingw64\bin;%CMAKE_PATH%\bin;%GIT_PATH%;%SEVENZIP%;%PATH%

set SOURCE_LEVEL=1.8
set TARGET_LEVEL=1.8
set TARGET_RT_JAR=C:\jre1.8.0_212\lib\rt.jar

set JOGAMP_JAR_CODEBASE=Codebase: *.jogamp.org

REM    -Dc.compiler.debug=true 
REM    -DuseOpenMAX=true 
REM    -DuseKD=true
REM    -Djogl.cg=1 -D-Dwindows.cg.lib=C:\Cg-2.2
REM    -Dbuild.noarchives=true

java  -server -Xmx1024m -XX:+UseCompressedOops -jar agent.jar -jnlpUrl https://jogamp.org/chuck/computer/win64-nvgtx460-win7-jogamp-x64-sgothel-011/slave-agent.jnlp 
