extends Node
class_name IncidentHelper

var incident_system : IncidentSystem = null

func _ready():
	incident_system = GameManager.get_gameplay_director().incident_system
	if incident_system == null:
		Logger.print_error('Failed to find incident system')
		
	assert(incident_system != null)
	
func raise_incident(definition : IncidentDefinition):
	var incident = IncidentSystem.Incident.new()
	incident.definition = definition
	incident_system.raise_incident(incident)
