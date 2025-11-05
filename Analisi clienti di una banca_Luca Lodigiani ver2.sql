SELECT 
cli.id_cliente, 

TIMESTAMPDIFF(YEAR, data_nascita, CURDATE()) AS eta,

/*
transazioni in uscita
*/
COUNT(CASE WHEN tipotransa.segno='-' THEN  1 ELSE NULL END) AS transazioni_uscita_numero,
/*
transazioni in entrata
*/
COUNT(CASE WHEN tipotransa.segno='+' THEN 1 ELSE NULL END) AS transazioni_entrata_numero,
/*
importo totale in uscita
*/
SUM(CASE WHEN tipotransa.segno='-' THEN transa.importo END) AS tot_transazioni_uscita,
/*
importo totale in entrata
*/
SUM(CASE WHEN tipotransa.segno='+' THEN transa.importo END) AS tot_transazioni_entrata,
/*
numero totale conti
*/
COUNT(DISTINCT CASE WHEN cont.id_tipo_conto IN (0,1,2,3) THEN cont.id_conto END) AS numero_totale_conti,
/*
Numero di conti posseduti per tipologia (un indicatore per ogni tipo di conto)
*/
COUNT( DISTINCT CASE WHEN cont.id_tipo_conto = 0 THEN 1 ELSE NULL END) conto_base,
COUNT( DISTINCT CASE WHEN cont.id_tipo_conto = 1 THEN 1 ELSE NULL END) conto_business,
COUNT( DISTINCT CASE WHEN cont.id_tipo_conto = 2 THEN 1 ELSE NULL END) conto_privato,
COUNT( DISTINCT CASE WHEN cont.id_tipo_conto = 3 THEN 1 ELSE NULL END) conto_famiglie,
/*
Numero di transazioni in uscita e in entrata per tipologia di conto (un indicatore per tipo di conto)
*/
COUNT(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 0 THEN 1 ELSE NULL END) uscite_conto_base,
COUNT(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 1 THEN 1 ELSE NULL END) uscite_conto_business,
COUNT(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 2 THEN 1 ELSE NULL END) uscite_conto_privato,
COUNT(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 3 THEN 1 ELSE NULL END) uscite_conto_famiglie,
COUNT(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 0 THEN 1 ELSE NULL END) entrate_conto_base,
COUNT(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 1 THEN 1 ELSE NULL END) entrate_conto_business,
COUNT(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 2 THEN 1 ELSE NULL END) entrate_conto_privato,
COUNT(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 3 THEN 1 ELSE NULL END) entrate_conto_famiglie,

/*
Importo transato in uscita e in entrata per tipologia di conto (un indicatore per tipo di conto).
*/
SUM(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 0 THEN transa.importo ELSE 0 END) importo_uscite_conto_base,
SUM(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 1 THEN transa.importo ELSE 0 END) Importo_uscite_conto_business,
SUM(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 2 THEN transa.importo ELSE 0 END) Importo_uscite_conto_privato,
SUM(CASE WHEN tipotransa.segno='-' AND cont.id_tipo_conto = 3 THEN transa.importo ELSE 0 END) Importo_uscite_conto_famiglie,
SUM(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 0 THEN transa.importo ELSE 0 END) Importo_entrate_conto_base,
SUM(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 1 THEN transa.importo ELSE 0 END) Importo_entrate_conto_business,
SUM(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 2 THEN transa.importo ELSE 0 END) Importo_entrate_conto_privato,
SUM(CASE WHEN tipotransa.segno='+' AND cont.id_tipo_conto = 3 THEN transa.importo ELSE 0 END) Importo_entrate_conto_famiglie


FROM banca.cliente cli
LEFT JOIN  banca.conto cont ON cli.id_cliente = cont.id_cliente
LEFT JOIN banca.tipo_conto tipcont ON cont.id_tipo_conto= tipcont.id_tipo_conto
LEFT JOIN banca.transazioni transa ON cont.id_conto = transa.id_conto
LEFT JOIN banca.tipo_transazione tipotransa ON transa.id_tipo_trans = tipotransa.id_tipo_transazione
GROUP BY 1,2;






