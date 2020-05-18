metaxploit = include_lib("/lib/metaxploit.so")
if not metaxploit then
    currentPath = get_shell.host_computer.current_path
    metaxploit = include_lib(currentPath + "/metaxploit.so")
end if
if not metaxploit then exit("Error: Can't find metaxploit library in the /lib path or the current folder")
metaLib = metaxploit.load("/lib/kernel_module.so")
if not metaLib then exit("Can't find " + "/lib/kernel_module.so")
result = metaLib.overflow("0x10C4E282", "_eob_lendpo")
if not result then exit("Program ended")
if typeof(result) != "file" then exit("Error: expected file, obtained: " + result)
if not result.is_folder then exit("Error: expected folder, obtained file: " + result.path)
if not result.has_permission("r") then exit("Error: can't access to " + result.path + ". Permission denied." )
print("Obtained access to " + result.path +". Listing files...")
files = result.get_files
for file in files
	print("File: " + file.name + ". Printing content...")
	if not file.has_permission("r") then
		print("failed. Permission denied.")

	else if file.is_binary then
		print("failed. Binary file.")

	else
		print(file.content)
	end if
end for
