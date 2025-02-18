extends Node
class_name IncidentSystem

class Incident:
	var definition : IncidentDefinition

@export var chaos_system : ChaosSystem
#@export var ai_system : AISystem

func raise_incident(incident : Incident):
	Logger.print("recieved incident: " + incident.definition.name)
	chaos_system.add_chaos(incident.definition.chaos_amount)
