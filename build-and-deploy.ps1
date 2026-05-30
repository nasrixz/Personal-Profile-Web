# Build + deploy Personal Profile Web to Tomcat 9
# Run from project folder:  powershell -ExecutionPolicy Bypass -File .\build-and-deploy.ps1

$ErrorActionPreference = "Stop"

$jdk     = "C:\Program Files\Java\jdk1.8.0_202\bin"
$tomcat  = "C:\Program Files\Apache Software Foundation\Tomcat 9.0"
$root    = $PSScriptRoot
$build   = "$root\build"
$webapp  = "$build\webapp"
$classes = "$webapp\WEB-INF\classes"
$jar     = "$build\lib\javax.servlet-api-4.0.1.jar"
$war     = "$build\profile.war"

# 1. Ensure servlet-api jar (download once from Maven Central)
New-Item -ItemType Directory -Force "$build\lib" | Out-Null
if (-not (Test-Path $jar)) {
    Write-Host "Downloading servlet-api..."
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest "https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/4.0.1/javax.servlet-api-4.0.1.jar" -OutFile $jar
}

# 2. Stage webapp (html, jsp, css, web.xml)
if (Test-Path $webapp) { Remove-Item -Recurse -Force $webapp }
New-Item -ItemType Directory -Force $classes | Out-Null
Copy-Item -Recurse -Force "$root\src\main\webapp\*" $webapp

# 3. Compile servlet
Write-Host "Compiling..."
& "$jdk\javac.exe" -encoding UTF-8 -cp $jar -d $classes "$root\src\main\java\com\nasri\profile\ProfileServlet.java"
if ($LASTEXITCODE -ne 0) { throw "javac failed" }

# 4. Package WAR
if (Test-Path $war) { Remove-Item -Force $war }
Push-Location $webapp
& "$jdk\jar.exe" -cf $war .
Pop-Location
Write-Host "Built $war"

# 5. Deploy to Tomcat webapps (needs admin -> UAC prompt)
$dst = "$tomcat\webapps\profile.war"
$cmd = "Copy-Item -Force -LiteralPath '$war' -Destination '$dst'"
Start-Process powershell -Verb RunAs -ArgumentList "-NoProfile","-Command",$cmd -Wait
Write-Host "Deployed. Open:  http://localhost:8080/profile/"
