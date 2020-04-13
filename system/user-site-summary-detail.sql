SELECT t1.userid as "Nutzer-ID",
    u.firstname as "Vorname",
    u.lastname as "Nachname",
	count(t1.timecompleted) as "Abgeschlossen",
	count(t1.id) as "Gesamt",
	CASE
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 10 THEN '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 20 THEN '⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 30 THEN '⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 40 THEN '⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 50 THEN '⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 60 THEN '⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 70 THEN '⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 80 THEN '⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 90 THEN '⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜'
		WHEN (count(t1.timecompleted) * 1.0 / count(t1.id) * 100) < 100 THEN '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜'
		ELSE '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛'
	END AS "Fortschritt",
	(round(count(t1.timecompleted) * 1.0 / count(t1.id) * 100)) as "Prozent",
    (round((SELECT AVG(finalgrade) FROM prefix_grade_grades WHERE userid = t1.userid ))) AS "Score", 
	case
	when (SELECT AVG(finalgrade) FROM prefix_grade_grades WHERE userid = t1.userid ) > (SELECT AVG(finalgrade) FROM prefix_grade_grades) THEN '↗'
	else '↘'
	end as "Vergleich",
    (SELECT COUNT(*) FROM prefix_logstore_standard_log WHERE action LIKE '%loggedin' AND userid = t1.userid) AS "Logins",
	(SELECT COUNT(*) FROM prefix_logstore_standard_log WHERE action NOT LIKE '%loggedin' AND userid = t1.userid AND action NOT LIKE '%loggedout') AS "Aktivität"
	
	
   FROM prefix_course_completions as t1
      JOIN prefix_user u ON t1.userid = u.id
	WHERE t1.userid > 2 
  GROUP BY t1.userid, u.firstname, u.lastname, u.lastaccess
