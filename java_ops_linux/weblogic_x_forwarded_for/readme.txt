use setDomainEnv.sh to get CLASSPATH

javac WlsXff.java

jar -cvf WlsXff.jar Wls_Xff.class

add WlsXff.jar to CLASSPATH

and then edit access log extended format
x-WlsXff

restart server 
