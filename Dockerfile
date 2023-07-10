FROM mcr.microsoft.com/windows/servercore:ltsc2022

# Install Chocolatey
RUN powershell -Command \
    Set-ExecutionPolicy Bypass -Scope Process -Force; \
    [System.Net.ServicePointManager]::SecurityProtocol = 3072; \
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install ImgBurn via Chocolatey
RUN choco install -y imgburn

# Set the entrypoint to run ImgBurn only when a command is provided
ENTRYPOINT ["cmd", "/S", "/C", "if not \"%*\"==\"\" (ImgBurn.exe %*)"]

# Add ImgBurn to the PATH
RUN setx /M PATH "%PATH%;C:\Program Files (x86)\ImgBurn"

# Verify the /NOIMAGEDETAILS argument is specified
CMD ["cmd", "/S", "/C", "if \"%1\"==\"/NOIMAGEDETAILS\" (echo \"Command accepted\") else (echo \"Error: The /NOIMAGEDETAILS argument is required\")"]
