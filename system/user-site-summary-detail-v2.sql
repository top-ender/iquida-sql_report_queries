This Query is similar to the user-site-summary-detail.sql ###
It still works after course completions criteria are changed ###
It counts number of courses instead of number of courses to be completed in mdl_course_completions ###

SELECT cc.userid AS "User-ID",
    CONCAT('<a target="_blank" href="%%WWWROOT%%/user/view.php?id=', cc.userid, '">', u.firstname, '</a>') AS "Vorname",
    u.lastname AS "Nachname",
	COUNT(DISTINCT cc.timecompleted) AS "Fertig",
	(SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) AS "Gesamt", 
	CASE
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 10 THEN '⬜⬜⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 20 THEN '⬛⬜⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 30 THEN '⬛⬛⬜⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 40 THEN '⬛⬛⬛⬜⬜⬜⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 50 THEN '⬛⬛⬛⬛⬜⬜⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 60 THEN '⬛⬛⬛⬛⬛⬜⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 70 THEN '⬛⬛⬛⬛⬛⬛⬜⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 80 THEN '⬛⬛⬛⬛⬛⬛⬛⬜⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 90 THEN '⬛⬛⬛⬛⬛⬛⬛⬛⬜⬜'
		WHEN (count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100) < 100 THEN '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬜'
		ELSE '⬛⬛⬛⬛⬛⬛⬛⬛⬛⬛'
	END AS "Fortschritt",
	(round(count(DISTINCT cc.timecompleted) * 1.0 / (SELECT COUNT(DISTINCT c.fullname) FROM prefix_course AS c
		JOIN prefix_context AS ctx ON c.id = ctx.instanceid
		JOIN prefix_role_assignments AS ra ON ra.contextid = ctx.id
		JOIN prefix_user AS u ON u.id = ra.userid
		WHERE u.id = cc.userid AND ra.roleid = 5) * 100)) as "Prozent",
    (round((SELECT AVG(finalgrade) FROM prefix_grade_grades WHERE userid = cc.userid ))) AS "Score", 
	case
	when (SELECT AVG(finalgrade) FROM prefix_grade_grades WHERE userid = cc.userid ) > (SELECT AVG(finalgrade) FROM prefix_grade_grades) THEN '↗'
	else '↘'
	end as "Vergleich",
    (SELECT COUNT(*) FROM prefix_logstore_standard_log WHERE action LIKE '%loggedin' AND userid = cc.userid) AS "Logins",
	(SELECT COUNT(*) FROM prefix_logstore_standard_log WHERE action NOT LIKE '%loggedin' AND userid = cc.userid AND action NOT LIKE '%loggedout') AS "Aktivität",
	(FROM_UNIXTIME(u.lastaccess, '%Y-%m-%d, %H:%i')) AS "Letzter Zugriff"
   FROM prefix_course_completions as cc
      JOIN prefix_user u ON cc.userid = u.id
	  JOIN prefix_role_assignments AS ra ON u.id = ra.userid
	WHERE ra.userid > 2 AND ra.roleid = 5
  GROUP BY cc.userid, u.firstname, u.lastname, u.lastaccess
