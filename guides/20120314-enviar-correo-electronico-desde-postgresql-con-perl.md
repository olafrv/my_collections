# Enviar correo electrónico desde PostgreSQL con PERL

Para poder enviar correos desde PostgreSQL en GNU/Linux existe una forma sencilla de hacerlo, un script PERL disponible dentro del manejador de base de datos a través de una función.

# Requerimientos

  * Todo esto ha sido probado en [GNU/Linux Debian Squeeze 6.0](https://www.debian.org)
  * Instalar el módulo de PERL "Mail::Sender": _apt-get install libmail-sender-perl_
  * Instalar "PLPERL" _apt-get install postgresql-plperl-8.3_. Para mayor información visite: <https://www.postgresql.org/docs/8.3/static/plperl.html>
  * Un servidor de correos local (opcional si tenemos otro servidor) instalado y configurado (por defecto): sendmail, exim4 o postfix.

# Manos a la obra

Debemos cargar el contenido del archivo pgmail.sql y pgmailt.sql que se muestan debajo, para crear la función de envío de correo y hacer pruebas, respectivamente. 

```bash
    root# su - postgres
    postgres$ psql < pgmail.sql 
    postgres$ psql < pgmailt.sql 
```

# Creación de la función "pgmail"

El archivo **pgmail.sql** contiene lo siguiente: 

```sql
    \c A;
    -- CREATE LANGUAGE plperlu;
    CREATE OR REPLACE FUNCTION pgmail(text, text, text, text) RETURNS INTEGER AS $$
    
    $from_address = $_[0];
    $to_address = $_[1];
    $subject = $_[2];
    $body = $_[3];
    
    #$reply_to = 'no-reply@localhost.localdomain';
    $server = 'localhost';
    
    use Mail::Sender;
    $sender = new Mail::Sender
    	{
    		smtp => $server, 
    		from => $from_address
    	};
    $rc = $sender->MailMsg(
    	{
    	#	replyto => $reply_to,
    		to => $to_address,
    		subject => $subject,
    		msg => $body
    	}
    );
    
    if(ref($rc)){
            return 0;
    }else{
    	elog(ERROR, $sender->{'error_msg'});
    	return $sender->{'error'};
    }
    
    $$ LANGUAGE plperlu VOLATILE STRICT;
```

# Prueba de "pgmail"

El archivo **pgmailt.sql** contiene lo siguiente: 

```sql
    \c A;
    select pgmail('me@localhost.localdomain', 'olafrv@gmail.com,olafrv@cantv.net','Mail desde postgres', 'Test!!!');
```