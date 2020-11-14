# Create virtual environment and activate
python -m venv v3
& ./v3/Scripts/Activate.ps1

# Install depencies
pip install --upgrade pip --user
pip install --upgrade setuptools cffi cython pypiwin32 -r requirements.txt
pip install https://github.com/pyinstaller/pyinstaller/tarball/develop

# python setup.py build_ext --inplace

# Bundle program
pyi-makespec -F --add-data "./images/*;images" --add-data "./*.png;." --add-data "./*.ico;." -w -i ./images/fablicator.ico fablicator.py
pyinstaller --clean fablicator.spec -y

# Clean release folder
Remove-Item ".\release\*" -Force

# Create installer
iscc .\win_installer.iss

# Package zip file
$archive = @{ 
    Path = ".\dist\fablicator.exe", ".\Documentation", ".\Configs" 
    DestinationPath = ".\release\fablicator_interface-win10.zip"
}

Compress-Archive -Path ".\dist\fablicator.exe", ".\Documentation", ".\Configs" -DestinationPath ".\release\fablicator_interface-win10.zip"
