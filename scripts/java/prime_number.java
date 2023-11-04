// javac prime_number.java
// java prime_number
public class prime_number{
	public static void main(String [] args){
		int numero=new Integer(args[0]).intValue();
		boolean esprimo=true;
		int divisor=0;
		for(int i=2;i<=(numero/2);i++){
			esprimo=esprimo && (numero%i!=0);
			if(!esprimo){
				divisor=i;
				break;
			}
		}
		System.out.println(esprimo+" - el divisor es "+divisor);
	}
}
