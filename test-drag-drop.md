# Testing Drag and Drop - Zen Browser

## ✅ **Fixed Flatpak Permissions**

I've added the following permissions to Zen browser:

1. **Filesystem Access:**
   - `--filesystem=home` - Access to home directory
   - `--filesystem=xdg-documents` - Access to Documents folder
   - `--filesystem=xdg-pictures` - Access to Pictures folder

2. **Portal Permissions:**
   - `--talk-name=org.freedesktop.portal.Desktop` - General desktop integration
   - `--talk-name=org.freedesktop.portal.FileChooser` - File chooser access
   - `--talk-name=org.freedesktop.portal.Documents` - Document portal access

## 🧪 **Test Steps:**

1. **Close Zen browser completely** (I already killed the process)
2. **Open Zen browser again**: `flatpak run app.zen_browser.zen`
3. **Test drag and drop**:
   - Open Thunar file manager
   - Navigate to a folder with some images or files
   - Drag a file from Thunar to Zen browser (any upload field or webpage)

## 🎯 **Expected Result:**
- Drag and drop should now work from Thunar to Zen browser
- File picker should also work when clicking "Choose file" buttons

## 🔍 **If still not working:**
Run the debug script: `./debug-portal.sh`