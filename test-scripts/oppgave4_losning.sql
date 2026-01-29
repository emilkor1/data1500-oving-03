-- Oppgave 1: Implementer RLS på studenter-tabellen slik at studenter bare ser sin egen data
ALTER TABLE studenter ENABLE ROW LEVEL SECURITY;

CREATE POLICY student_see_self ON studenter
    FOR SELECT
    USING (
        student_id = (
            SELECT student_id FROM bruker_student_mapping
            WHERE brukernavn = current_user
        )
    );

-- Oppgave 2: Opprett en policy som tillater foreleser å se alle karakterer
/*
Uklart hvordan dette skal gjøres uten USING.
*/
CREATE POLICY professor_read_grades ON emneregistreringer
    FOR SELECT
    TO foreleser_role
    USING (true);

-- Oppgave 3: Lag en view foreleser_karakteroversikt som viser studentnavn, emnenavn og karakter
CREATE VIEW foreleser_karakteroversikt AS
SELECT fornavn, etternavn, karakter, e.emne_navn FROM (
    SELECT s.fornavn, s.etternavn, er.karakter, er.emne_id
    FROM studenter AS s
    RIGHT JOIN emneregistreringer AS er ON s.student_id = er.student_id
) AS table1
LEFT JOIN emner AS e ON e.emne_id = table1.emne_id;

-- Oppgave 4: Implementer en policy som forhindrer at noen sletter karakterer
CREATE POLICY reject_delete_grades
    ON emneregistreringer
    FOR DELETE
    TO PUBLIC
    USING (false);

-- Oppgave 5: Lag en audit-tabell som logger alle endringer av karakterer
/* Identisk til OPPGAVE4.md bonus. */
