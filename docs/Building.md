# Platforms 

Dichromate was developed targetting Windows, so the instructions will reflect that. 

It can be compiled on other platforms as well, but some of the hardening features may not be available.

# Setup

+ Install Visual Studio <a href="https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes">2019</a> or <a href="https://docs.microsoft.com/en-us/visualstudio/releases/2022/release-notes">2022</a>. Google recommends Visual Studio 2019, but 2022 will also do fine.

+ In the Visual Studio Installer, check the box to install `Desktop Development with C++` and in the optional section, install `Windows 10 SDK (10.0.20348.0)`, `C++ ATL`, and `C++ MFC`.

+ When the installation is complete, go to Control Panel → Programs → Programs and Features → Select the “Windows Software Development Kit” → Change → Change → Check “Debugging Tools For Windows” → Change.

+ Download the depot_tools bundle <a href="https://storage.googleapis.com/chrome-infra/depot_tools.zip">here</a>.

+ Make a directory `C:\src` 

+ Extract the zip file to `C:\src` and add `C:\src\depot_tools` to your PATH by going to Control Panel → System and Security → System → Advanced system settings, double clicking the PATH variable, and adding `C:\src\depot_tools` to the list. **Make sure it is ahead of any Python or Git installations.**

+ In the same menu, add an environment variable `vs2022_install` or `vs2019_install` depending your version of VS.
    + For VS 2022, set `vs2022_install` to `C:\Program Files\Microsoft Visual Studio\2022\Community`. 
    + For VS 2019 set `vs2019_install` to ` C:\Program Files (x86)\Microsoft Visual Studio\2019\Community`.

+ Additionally, set the environment variable `DEPOT_TOOLS_WIN_TOOLCHAIN` to `0` , to tell GN to use a local installation of Visual Studio instead of Google's internal version.

# Install dependencies using `depot_tools`

Strictly from a CMD.exe shell (no PowerShell allowed), run:
 ```   
> gclient
```
Using a shell other can CMD can cause issues with the installation, so stick to CMD only.

This will command install Git, Python, and other dependencies for Chromium. 

After running `gclient`, in the same shell, run `where python` and make sure `python.bat` is ahead of any other Python executables. If not, re-order the PATH variable accordingly.

# Download the Chromium source 

From here, CMD.exe is not a necessity, and other shells can be used.

First, configure Git.
```
$ git config --global user.name "Name"
$ git config --global user.email "name@example.org"
$ git config --global core.autocrlf false
$ git config --global core.filemode false
```
Then,
```
$ cd C:\src
$ mkdir dichromate && cd dichromate
```
Downloading the source can take a long time depending on your internet speed. The Chromium source tree is around 35 gigabytes. You have been warned. 

Run the following to checkout the source:

    $ fetch chromium

When the checkout completes, you will have a `.gclient` file in the working directory.

Modify it so that it looks like this.

```
solutions = [
  {
    "name": "src",
    "url": "https://chromium.googlesource.com/chromium/src.git",
    "managed": False,
    "custom_deps": {},
    "custom_vars": {
      "checkout_pgo_profiles": True,
    },
  },
]
```

# Setting up the Build
Move into the src directory. 

```
$ cd src
```

Now fetch all the tags from the repository. This can take a while.

```
$ git fetch --tags
```

Check out the latest version of Dichromate, which can be found in `version.txt` in the root of the Dichromate repository. Replace $version with the number.
```
$ git checkout $version
```

Now download all the dependencies for the current version.
```
$ cd ..
$ gclient sync -D
$ cd src
```
This may take a while. 

# Applying the Dichromate patches

Clone the Dichromate repository
```
$ cd C:\src\
$ git clone https://github.com/NuclearDevelopers/Dichromate.git
```

The localization branding patch that Dichromate uses is too large for GitHub, so it is compressed using [Zstandard](https://github.com/facebook/zstd).

To be able to apply the patch, install Zstd from the link given above.

From the patches folder in the Dichromate repository, "C:\src\Dichromate\patches" in this case, run:
```
zstd -d *-Dichromate-localization-rebranding.patch.zst
```

Note that this is not required if you do not require branding in extra languages.

Now, apply the patches

```
$ cd C:\src\chromium\src
$ git am --whitespace=nowarn (dir D:\src\Dichromate\patches\*.patch)
```
# Starting the build

First, create the output directory: 
```
$ mkdir -p out\Default
```
`Default` can be replaced with anything, but the `out` part cannot be modified.

Now, set the build parameters.
```
$ gn args out\Default
```
A text editor will appear after this command is run. Copy the contents of args.gn in the Dichromate repository and paste it into the file.

Closing the editor makes `gn` start generating `.ninja` files for the build. 

When that is done, we can start the build:
```
$ autoninja -C out\Default mini_installer -j 10
```

Replace 10 with the number of threads your system has. 
The build can take anywhere from an hour to 8 hours, depending on how powerful your computer is. 

Dichromate uses as much optimization as possible to improve build times, but due to Chromium's large size, it still takes a very long time. 

When the build is done, Dichromate can be run using:
```
out\Default\chrome.exe
```

To install it, run:
```
out\Default\mini_installer.exe
```
When it is done, Dichromate will appear in your start menu and on your Desktop.
