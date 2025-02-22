extends Resource
class_name TextFileResource

@export var text_file_name: String  # Just the filename (e.g., "myFile")

func get_text() -> String:
	if resource_path.is_empty():
		push_error("Resource path is empty. Ensure this resource is saved.")
		return ""

	var directory_path = resource_path.get_base_dir()  # Get the folder path
	var text_file_path = directory_path.path_join(text_file_name + '.txt')  # Resolve full path

	if FileAccess.file_exists(text_file_path):
		var file = FileAccess.open(text_file_path, FileAccess.READ)
		return file.get_as_text()
	else:
		push_error("File does not exist: " + text_file_path)
		return ""
