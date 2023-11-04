/***
 * ARCHIVO: test.java
 * USO: Autenticación de un usuario LDAP
 * AUTOR: Olaf Reitmaier <olafrv@gmail.com> (07 de Octubre de 2008)
 */

import java.util.Hashtable;
import javax.naming.*;
import javax.naming.directory.*;

// javac ldap_test.java
// java ldap_test ldap.dem.int dc=dem,dc=int uid usuario clave
// java ldap_test ldap.dem.int dc=dem,dc=int mobile cedula clave
class test{

   public static void main(String args[]){
      String servidor = args[0];
      String dn_base = args[1];
      String campo_unico = args[2];
      String valor = args[3];
      String clave = args[4];

      String dn = LDAP.buscarDN(servidor, dn_base, campo_unico, valor); 
     
      boolean autenticado = LDAP.autenticarDN(servidor, dn_base, dn, clave);

      if (autenticado){
          System.out.println("Autenticado.");
      }else{
          System.out.println("No Autenticado.");      
      }
   }
}

final class LDAP{
  
  public LDAP(){}
  
   /** 
    * Busca el DN de un usuario utilizando un campo unico
    * en un directorio LDAP
    *
    * @param servidor    172.26.96.184
    * @param dn_base     dc=dem,dc=int
    * @param campo_unico uid, gid, etc de la entrada
    * @param valor       valor del campo unico
    */
  public static final String buscarDN(String servidor, String dn_base, String campo_unico, String valor){
   
     Hashtable entorno = new Hashtable(11); 
    
     entorno.put(Context.INITIAL_CONTEXT_FACTORY,"com.sun.jndi.ldap.LdapCtxFactory");
     entorno.put(Context.PROVIDER_URL, "ldaps://" + servidor.toString() + ":636/" + dn_base);
     entorno.put(Context.SECURITY_AUTHENTICATION, "none");
    
     String[] atributos = {"dn"}; //Lista de atributos resultado
   
     SearchControls controles = new SearchControls(); //Motor de búsqueda
   
     controles.setReturningAttributes(atributos); // Establecer atributos de resultado
   
     controles.setSearchScope(SearchControls.SUBTREE_SCOPE); //Alcance
   
     String filtro = "(" + campo_unico.toString() + "=" + valor.toString() + ")"; //Filtro

     String dn = null;

     try {
        DirContext contexto = new InitialDirContext(entorno);
        NamingEnumeration resultado = contexto.search("", filtro, controles);
        SearchResult item = (SearchResult) resultado.next();
        dn = item.getName() + "," + dn_base;
        //String tmp = item.getAttributes().toString();
        //System.out.println("Atributos" + tmp);
        //System.out.println("dn: " + dn);
     } catch (Exception e) {
        System.out.println("Error desconocido 1 !!!");
        e.printStackTrace();
     }
     return dn;
   }
   
   /** 
    * Autentica un usuario contra un directorio LDAP
    *
    * @param servidor    172.26.96.184
    * @param dn_base     dc=dem,dc=int
    * @param dn_usuario  uid=oreitmaier,ou=Usuarios,ou=Personas,dc=dem,dc=int (utilizar buscarDN con uid)
    * @param clave       123456
    */
   public static final boolean autenticarDN(String servidor, String dn_base, String dn_usuario, String clave){
      boolean autenticado = false;
      Hashtable entorno = new Hashtable(11); 
      entorno.put(Context.INITIAL_CONTEXT_FACTORY, "com.sun.jndi.ldap.LdapCtxFactory");
      entorno.put(Context.PROVIDER_URL, "ldaps://"+servidor+":636/"+dn_base);
      entorno.put(Context.SECURITY_AUTHENTICATION, "simple");
      entorno.put(Context.SECURITY_PRINCIPAL, dn_usuario);
      entorno.put(Context.SECURITY_CREDENTIALS, clave.toString());
      try {
         DirContext contexto = new InitialDirContext(entorno);
         autenticado = true;
      } catch (AuthenticationException authEx) {
         System.out.println("Clave incorrecta!!!");
      } catch (Exception e) {
         System.out.println("Error desconocido 2 !!!");
         e.printStackTrace();
      }
      return autenticado;
   }
}


