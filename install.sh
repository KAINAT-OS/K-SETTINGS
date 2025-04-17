cd /tmp
echo $PASSWORD | sudo -S mkdir /K-installer
cd K-installer
git clone https://github.com/KAINAT-OS/K-SETTINGS.git
cd K-SETTINGS/binary-settings/Builds/linux/
echo $PASS | sudo -S bash ./build.sh
echo "$PASSWORD" | sudo -S dpkg -i ./*.deb
cd /tmp/K-installer

DEST_DIR="/usr/share/binary-updater/K-SETTINGS"
SOURCE_FILE="version.sh"
sed -i 's/VERSION/offline_version/g' $SOURCE_FILE
# Check if directory exists
if [ ! -d "$DEST_DIR" ]; then
    echo "Directory does not exist. Creating: $DEST_DIR"
    sudo mkdir -p "$DEST_DIR"
fi

# Copy the file
echo "Copying $SOURCE_FILE to $DEST_DIR"
echo "$PASSWORD" | sudo -s  cp "$SOURCE_FILE" "$DEST_DIR"
echo done
