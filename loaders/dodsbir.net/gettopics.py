from dodsbirscrape import DODSBIRScrape

def save_all():
	s = DODSBIRScrape()
	s.stage_current_solicitation()
	s.get_all_topics()
	s.save_as_json("workfiles/alltopics.json")

save_all()
