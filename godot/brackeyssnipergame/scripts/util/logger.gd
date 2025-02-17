extends Node

func print_error(text : Variant) -> void:
	Console.print_error(text, true)
	
func print(text : Variant) -> void:
	Console.print_line(text, true)
