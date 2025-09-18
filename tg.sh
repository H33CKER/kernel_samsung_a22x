#!/bin/bash

# bot information
BOT_TOKEN="8309425600:AAFnL3ADuC_9xCcIs3lJvgmh2wbncbc1fDg"
CHAT_ID="-1002945608895"

# Path variable
HOME="$(pwd)"
ZIP_NAME="A22-$(date +%Y%m%d-%H%M).zip"
OUT_IMG="$HOME/out/arch/arm64/boot/Image.gz"
ANYKERNEL="$HOME/AnyKernel3"

# Salin & zip
cp "$OUT_IMG" "$ANYKERNEL/"
cd "$ANYKERNEL" || exit 1
zip -r9 "$ZIP_NAME" * > /dev/null
rm -f Image.gz

# Tanggal Dibuat
DATE=$(date +"%d-%m-%Y %H:%M")

# Ambil kernel version
if [ -f "$OUT_IMG" ]; then
  KERNEL_VER=$(gzip -dc "$OUT_IMG" \
                | strings \
                | grep -m1 "Linux version" )
else
  KERNEL_VER="Unknown"
fi

# Caption
CAPTION="*A226B-$DATE*
\`\`\`
LocalVersion :
$KERNEL_VER
\`\`\`
"

# Upload to Telegram
curl -F document=@"$ZIP_NAME" \
     -F "chat_id=$CHAT_ID" \
     -F "caption=$CAPTION" \
     -F "parse_mode=Markdown" \
     https://api.telegram.org/bot$BOT_TOKEN/sendDocument
# clean
cd $ANYKERNEL
rm -rf $ZIP_NAME
cd $HOME
