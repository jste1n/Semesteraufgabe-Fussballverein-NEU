--#########################################################
-- s1 1330538
-- eine persnr wählen aus angestellten 
-- fanclub die im monat NICHT  von der persnr betreut wird
-- ausgabe: sid, namen von fanclub,

-- select sid, name
-- from zeitraum
-- where persnr!=1330538 
-- and Extract(month from ende) = Extract(month from CURRENT_DATE)
-- and Extract(year from ende) = Extract(year from CURRENT_DATE)-1
-- limit 25
-- ;

--#########################################################
-- s2
-- nachname, persnr
-- von angestellten
-- fanclub betreuen
-- sortiren nachname

-- select zeitraum.persnr, zeitraum.name, zeitraum.anfang, zeitraum.ende, person.nname
-- from zeitraum inner join person on zeitraum.persnr = person.persnr
-- WHERE ende >= '2015-04-01' and ende <= '2015-04-30'
-- order by person.nname ASC
-- ;

--#########################################################
-- s3

-- datum nur einmal
-- select namen.bezeichnung, datum, namen.nname, namen.vname, dauer
-- from beteiligtespieler inner join (select bezeichnung, person.nname, person.vname, spielerinmannschaft.persnr
									-- from spielerinmannschaft inner join person 
									-- on spielerinmannschaft.persnr = person.persnr
									-- order by bezeichnung) as namen
-- on beteiligtespieler.persnr = namen.persnr
-- where Extract(year from datum) = '2015'
-- order by datum
-- ;

--#########################################################
--s4
-- nname vname gesamt dauer
-- jahr 2015


-- select distinct persnr, 0 as gesamtdauer, datum
-- from beteiligtespieler
-- where Extract(year from datum) != 2015
-- group by persnr
-- union
-- select distinct persnr, sum(dauer), datum
-- from beteiligtespieler
-- WHERE Extract(year from datum) = 2015
-- group by datum, persnr
-- order by datum
-- ;


--#########################################################
--s5

-- select person.nname, person.vname, t3.dauer
-- from person inner join (select distinct persnr, dauer, datum
						-- from beteiligtespieler t1
						-- WHERE Extract(year from datum) = 2015 
						-- and dauer = (select max(dauer)
									-- from beteiligtespieler t2	
									-- where Extract(year from t2.datum) = 2015 )
						-- group by persnr, datum) as t3
-- on t3.persnr = person.persnr
-- order by person.nname asc, person.vname asc
-- ;


--#########################################################
--s6

-- create view trainer_view as
	-- select trainer.persnr, person.vname, person.nname, person.geschlecht, person.gebdat, trainer.gehalt, trainer.von, trainer.bis
	-- from trainer inner join person 
	-- on trainer.persnr = person.persnr;

-- DROP VIEW IF EXISTS trainer_view CASCADE;








