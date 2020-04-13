Course completion and site activity ###
How many courses are completed, total number of courses to be completed for each student ###

SELECT cc.userid AS "User-ID",
    CONCAT('<a target="_blank" href="%%WWWROOT%%/user/view.php?id=', cc.userid, '">', u.firstname, '</a>') AS "Vorname",
    u.lastname AS "Nachname",
	COUNT(cc.timecompleted) AS "Abgeschlossen",
	COUNT(cc.id) AS "Gesamt",
	CASE
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 10 THEN '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 20 THEN '⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 30 THEN '⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 40 THEN '⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 50 THEN '⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 60 THEN '⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 70 THEN '⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 80 THEN '⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 90 THEN '⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜'
		WHEN (count(cc.timecompleted) * 1.0 / count(cc.id) * 100) < 100 THEN '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜'
		ELSE '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛'
	END AS "Fortschritt",
	(ROUND(COUNT(cc.timecompleted) * 1.0 / COUNT(cc.id) * 100)) as "Prozent",
    	(ROUND((SELECT AVG(finalgrade) FROM prefix_grade_grades WHERE userid = cc.userid ))) AS "Score", 
	CASE
		WHEN (SELECT AVG(finalgrade) FROM prefix_grade_grades WHERE userid = cc.userid ) > (SELECT AVG(finalgrade) FROM prefix_grade_grades) THEN '↗'
		ELSE '↘'
	END AS "Vergleich",
    	(SELECT COUNT(*) FROM prefix_logstore_standard_log WHERE action LIKE '%loggedin' AND userid = cc.userid) AS "Logins",
	(SELECT COUNT(*) FROM prefix_logstore_standard_log WHERE action NOT LIKE '%loggedin' AND userid = cc.userid AND action NOT LIKE '%loggedout') AS "Aktivität",
	(FROM_UNIXTIME(u.lastaccess, '%Y-%m-%d, %H:%i')) AS "Letzter Zugriff"
FROM prefix_course_completions as cc
	JOIN prefix_user u ON cc.userid = u.id
	JOIN prefix_role_assignments AS ra ON u.id = ra.userid
WHERE ra.userid > 2 AND ra.roleid = 5
GROUP BY cc.userid, u.firstname, u.lastname, u.lastaccess
