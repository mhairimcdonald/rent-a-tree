/**
 * 
 */
package util;

/**
 * @author owens
 *
 */
public class DbSetup {
	
	/*
	 * Setup and teardown scripts used to create/remove the tables we're working with
	 */
	
	private static final String SETUP_SCRIPT = "etc/RentATree.sql";
	private static final String TEARDOWN_SCRIPT = "etc/DropTables.sql";
	

	/**
	 * @param args
	 */
	public static void main(String[] args) {
		if(args.length>0){
			if(args[0].equals("setup")){
				setup();
				System.out.println("Process completed");
			}
			else if (args[0].equals("clear")){
				clear();
				System.out.println("Process completed");
			}
			else if(args[0].equals("reset")){
				clear();
				setup();
				System.out.println("Process completed");
			}
			else{
				help();
			}
		}
		else {
			help();
		}
	}
	
	public static void help(){
		System.out.println("This application creates or removes the underlying tables and other material needed by the application.\n"
				+ "\nRun with an argument:\n"
				+ " java <this file> setup - runs the table (etc.) creation script.\n"
				+ " java <this file> clear - runs the table (etc.) removal script.\n"
				+ " java <this file> reset - runs the removal script, then the creation script.\n"
				+ " with any other argument, or no arguments, displays this message.\n\n"
				
				
				);
	}
	
	public static void setup(){
		// create and populate data tables
		DbConnector.runSqlScript(SETUP_SCRIPT);
	}
	
	public static void clear(){
		// remove data tables and related items
		DbConnector.runSqlScript(TEARDOWN_SCRIPT);
		
	}
	
	

}
