# Create virtual environment and activate
python -m venv v3
& ./v3/Scripts/Activate.ps1

# Install depencies
pip install --upgrade pip --user
pip install --upgrade setuptools
pip install cffi
pip install -r requirements.txt
pip install cython
python setup.py build_ext --inplace
pip install https://github.com/pyinstaller/pyinstaller/tarball/develop
pip install pypiwin32

# Bundle program
pyi-makespec -F --add-data "./images/*;images" --add-data "./*.png;." --add-data "./*.ico;." -w -i ./images/fablicator.ico fablicator.py
pyinstaller --clean fablicator.spec -y

# Create installer
iscc .\win_installer.iss

# Package zip file
$archive = @{
    Path = ".\dist\fablicator.exe", ".\Documentation", ".\Configs"
    DestinationPath = ".\release\fablicator_interface-win10.zip"
}

Compress-Archive @archive
