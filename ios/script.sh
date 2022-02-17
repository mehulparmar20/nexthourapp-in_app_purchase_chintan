{\rtf1\ansi\ansicpg1252\cocoartf2580
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fnil\fcharset0 .AppleSystemUIFontMonospaced-Regular;}
{\colortbl;\red255\green255\blue255;\red35\green38\blue42;\red244\green244\blue244;\red8\green64\blue128;
\red69\green105\blue13;\red83\green92\blue101;}
{\*\expandedcolortbl;;\cssrgb\c18431\c20000\c21569;\cssrgb\c96471\c96471\c96471;\cssrgb\c392\c32941\c57647;
\cssrgb\c33725\c47843\c5098;\cssrgb\c40000\c43529\c47059;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\deftab720
\pard\pardeftab720\partightenfactor0

\f0\fs26 \cf2 \cb3 \expnd0\expndtw0\kerning0
#!/usr/bin/env bash\
#Place \cf4 this\cf2  script \cf4 in\cf2  project/ios/\
\
echo \cf5 "Uninstalling all CocoaPods versions"\cf2 \
sudo gem uninstall cocoapods --all --executables\
\
COCOAPODS_VER=`sed -n -e \cf5 's/^COCOAPODS: \\([0-9.]*\\)/\\1/p'\cf2  Podfile.lock`\
\
echo \cf5 "Installing CocoaPods version \cf2 $COCOAPODS_VER\cf5 "\cf2 \
sudo gem install cocoapods -v $COCOAPODS_VER\
\
# fail \cf4 if\cf2  any command fails\
\cf4 set\cf2  -e\
# debug log\
\cf4 set\cf2  -x\
\
pod setup\
\
cd ..\
git clone -b beta https:\cf6 //github.com/flutter/flutter.git\cf2 \
\cf4 export\cf2  PATH=`pwd`/flutter/bin:$PATH\
\
flutter channel master\
flutter doctor\
flutter pub \cf4 get\cf2 \
\
echo \cf5 "Installed flutter to `pwd`/flutter"\cf2 \
\
flutter build ios --release --no-codesign}