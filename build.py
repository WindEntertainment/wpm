import fnmatch
import zipfile
import os

patterns_to_ignore = [  
    "./build.py",
    "./install.bash",
    "./install.ps1",
    "./.gitignore",
    "*.zip",
    "./.git/**",
    "./.github/**"
]

zip_name = "source.zip"
files_to_zip = []

def should_ignore(file_name, patterns):
    for pattern in patterns:
        if fnmatch.fnmatch(file_name, pattern):
            return True
    return False

for root, dirs, files in os.walk("."):
    rel_root = os.path.relpath(root)
    if should_ignore(rel_root, patterns_to_ignore):
        continue

    for file in files:
        file_path = os.path.join(root, file)

        if should_ignore(file_path, patterns_to_ignore):
            continue

        files_to_zip.append(file_path)

if __name__ == "__main__":
    with zipfile.ZipFile(zip_name, 'w') as zipf:
        for file in files_to_zip:
            print("Adding file: ", file)
            zipf.write(file, file)

    print(f"Successful created {zip_name}")