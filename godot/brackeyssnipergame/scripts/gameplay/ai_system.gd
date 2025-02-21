extends Node
class_name AiSystem

var npcs : Dictionary#<guid,NpcController>

func register_npc(npc_controller : NpcController):
	if npcs.find_key(npc_controller) == null:
		var guid = UUID.v4()
		npcs[guid] = npc_controller
	else:
		Logger.print_error('tried registering an npc when it was already registered with the ai system')

func _on_chaos_changed(amount : int):
	for guid in npcs:
		var npc = npcs[guid] as NpcController
		npc.notify_panic(amount > 90)
