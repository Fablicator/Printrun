# -*- mode: python ; coding: utf-8 -*-

block_cipher = None


a = Analysis(['fablicator.py'],
             pathex=['C:\\Users\\kcald\\Documents\\GitHub\\Printrun'],
             binaries=[],
             datas=[('images/*', 'images'), ('*.png', '.'), ('*.ico', '.')],
             hiddenimports=[],
             hookspath=[],
             runtime_hooks=[],
             excludes=[],
             win_no_prefer_redirects=False,
             win_private_assemblies=False,
             cipher=block_cipher,
             noarchive=False)
pyz = PYZ(a.pure, a.zipped_data,
             cipher=block_cipher)
exe = EXE(pyz,
          a.scripts,
          [],
          exclude_binaries=True,
          name='fablicator',
          debug=False,
          bootloader_ignore_signals=False,
          strip=False,
          upx=True,
          console=False , icon='images\\fablicator.ico')
coll = COLLECT(exe,
               a.binaries,
               a.zipfiles,
               a.datas,
               strip=False,
               upx=True,
               upx_exclude=[],
               name='fablicator')
