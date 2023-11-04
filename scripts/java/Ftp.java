/**
* FILE: Ftp.java
* DESCRIPTION: A ftp uploader GUI class
* LIMITATION: Uses AWT instead of SWING
* VERSION: 09-Feb-2006
*
* Olaf says:
*
* -- Remenber, all is posible but the problem
* is the time you are able to spend doing it. --
*/

import java.io.*;
import java.net.*;
import java.awt.*;

/**
* An ftp uploader class (GUI File Selector)
* @author Olaf Reitmaier (olafrv@gmail.com)
*/
public class Ftp{

    public static void main(String args[]) throws Exception{
    
        int PIECE_SIZE = 7000; //Byte transfer rate (56 Kbps = 7KB)
        int bytes = 0; //Temp var of read bytes
        byte[] piece = new byte[PIECE_SIZE]; //Temp var of file pieces
        
        String server = "a_server_ip"; //The ftp server
        String user = "an_user"; //The ftp user
        String password = "a_passwd"; //The ftp password
        
        String[] files=selectFile();
        
        if(files[0]!=null && files[1]!=null){
        
            String localFile = files[0]+File.separator+files[1];
            String remoteFile = "/"+files[1];
            
            String strUrl = "ftp://"+user+":"+password+"@"+server+remoteFile+";type=i";
            
            URL url = new URL(strUrl);
            URLConnection urlc = url.openConnection();
            
            FileInputStream fis = new FileInputStream(new File(localFile));
            OutputStream os = urlc.getOutputStream();
            
            while(true){
                bytes = fis.available();
                if (bytes<=0){ 
                    break; 
                }else{ 
                    if (bytes>=PIECE_SIZE){
                        fis.read(piece,0,PIECE_SIZE);
                        os.write(piece,0,PIECE_SIZE);
                    }else{
                        fis.read(piece,0,bytes);
                        os.write(piece,0,bytes);
                    }
                }
            }
            os.close(); //Close the remote file stream
            fis.close(); //Close the local file stream
        }
    }
    
    /**
    * An AWT File Chooser
    * Courtesy of Jose Carrero <josercl@gmail.com>
    * @return A string array with the first position
    * containing the fullpath of the selected file
    */
    
    public static String[] selectFile(){
    
        String[] files=new String[2];
        
        Frame frame=new Frame();
        
        FileDialog file_chooser=new FileDialog(frame);
        
        file_chooser.show();
        
        files[0]=file_chooser.getDirectory();
        
        files[1]=file_chooser.getFile();
        
        file_chooser.dispose(); //Needed to terminates the program
        
        frame.dispose(); //Needed to terminates the program
        
        return files;
    
    }
    
}
