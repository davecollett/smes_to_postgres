truncate table scn.mark_description cascade;
insert into scn.mark_description select * from smes.mark_description;


#truncate table scn.msr_comments cascade;
#truncate table scn.proj_comments cascade;
#truncate table scn.adjustment cascade;

#INSERT INTO scn.msr_comments (msr_comment_id, msr_comments) 	VALUES (3, '* VICSCN_160704msr.xml');
		
#INSERT INTO scn.proj_comments (project_id, project_name, project_comments, project_source)		VALUES (5, 'VICSCN_160704-FULL', 'VICSCN_160704 Daily Processing', 'OSGV');
		
#INSERT INTO scn.adjustment (adj_id, adj_date, adj_d_code,  adj_runby, adj_type)	VALUES (5, '04/Jul/16', 'GDA94', 'DC', 'CGA');
		
