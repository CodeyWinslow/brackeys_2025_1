extends Node
class_name IncidentSystem

class Incident:
	var definition : IncidentDefinition

func raise_incident(incident : Incident):
	Logger.print("recieved incident: " + incident.definition.name)
