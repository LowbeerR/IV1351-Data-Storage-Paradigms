package integration;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import integration.*;

import model.*;
import static java.lang.System.out;
public class RentalDAO {
    private PreparedStatement intrumentcheck;
    private PreparedStatement studentrentals;
    private PreparedStatement instruments;
    private PreparedStatement allinstruments;
    private PreparedStatement addrent;
    private PreparedStatement updateinstrument;
    private PreparedStatement terminaterent;
    private PreparedStatement activerental;
    private Connection connection;
    private LocalDate date = LocalDate.now();


    private static final String STUDENT_TABLE_NAME = "student";
    private static final String STUDENT_PK_COLUMN_NAME = "student_id";

    private static final String INSTRUMENT_TABLE_NAME = "instrument";
    private static final String INSTRUMENT_INSTRUMENT_COLUMN_NAME = "instrument";
    private static final String INSTRUMENT_PK_COLUMN_NAME = "instrument_id";
    private static final String INSTRUMENT_PRICE_COLUMN_NAME = "price";
    private static final String INSTRUMENT_IN_STOCK_COLUMN_NAME = "in_stock";
    private static final String INSTRUMENT_BRAND_COLUMN_NAME = "brand";

    private static final String RENTAL_TABLE_NAME = "rental";
    private static final String RENTAL_LEASE_PERIOD_COLUMN_NAME = "lease_period";
    private static final String RENTAL_FK_COLUMN_NAME = INSTRUMENT_PK_COLUMN_NAME;
    private static final String RENTAL_FK_STUDENT_COLUMN_NAME = STUDENT_PK_COLUMN_NAME;



    public RentalDAO() throws RentalDBException{
        try{
            connectDB();
            prepareStatements();
        }
        catch (Exception e){
            out.println(e);
        }
    }
    public void terminate(Integer student, Integer instrument)throws RentalDBException{
        int updatedRows = 0;
        int updatedRows2 = 0;
        try{
            terminaterent.setInt(1,instrument);
            terminaterent.setInt(2,student);
            updateinstrument.setString(1,"true");
            updateinstrument.setInt(2,instrument);
            updatedRows = terminaterent.executeUpdate();
            updatedRows2 = updateinstrument.executeUpdate();
            if(updatedRows != 1 || updatedRows2 != 1)
                throw new RentalDBException("Something went wrong");
            connection.commit();
        }
        catch(Exception e)
        {
            handleException("Error while terminating ", e);}

    }
    public void rent (Integer student, Integer instrument)throws RentalDBException{
       int updatedRows = 0;
       int updatedRows2 = 0;
        try{
            addrent.setString(1,date.toString());
            addrent.setInt(2,instrument);
            addrent.setInt(3,student);
            updateinstrument.setString(1,"false");
            updateinstrument.setInt(2,instrument);
            updatedRows = addrent.executeUpdate();
            updatedRows2 = updateinstrument.executeUpdate();
            if(updatedRows != 1 || updatedRows2 != 1)
                throw new RentalDBException("Something went wrong");
            connection.commit();
        }
        catch(Exception e){
            handleException("error while renting ", e);
        }

    }
    public int checkinstrument(Integer instrument)throws RentalDBException{
        int ret = -1;
        try{
            intrumentcheck.setInt(1,instrument);
            ResultSet result = intrumentcheck.executeQuery();
            while(result.next())
                ret = result.getInt("count");
            connection.commit();
        }catch(Exception e){out.println("instrument not available");}
        return ret;
    }
    public int checkstudentrentals(Integer student)throws RentalDBException{
       int ret = -1;
        try{
            studentrentals.setInt(1, student);
            ResultSet result = studentrentals.executeQuery();
            while(result.next())
             ret = result.getInt("count");
            connection.commit();
        }
        catch(Exception e) {
            handleException("could not list instruments for student", e);
        }
        return ret;
    }


    public List<Instrument> instruments(String instrument) throws RentalDBException
    {
        List<Instrument> instruments1 = new ArrayList<>();
        try{

            instruments.setString(1,instrument);
            ResultSet result = instruments.executeQuery();
            while (result.next()){
                instruments1.add(new Instrument(result.getInt(INSTRUMENT_PK_COLUMN_NAME),result.getString(INSTRUMENT_BRAND_COLUMN_NAME),
                                                result.getString(INSTRUMENT_PRICE_COLUMN_NAME)));
            }
            connection.commit();
        }

        catch (Exception e){
            handleException("could not list instruments ", e);
        }
        return instruments1;

    }
    public List<Instrument> allInstruments() throws RentalDBException
    {
        List<Instrument> instruments = new ArrayList<>();
        try{
            ResultSet result = allinstruments.executeQuery();
            while (result.next()){
                instruments.add(new Instrument(result.getInt(INSTRUMENT_PK_COLUMN_NAME),result.getString(INSTRUMENT_PRICE_COLUMN_NAME),
                        result.getString(INSTRUMENT_INSTRUMENT_COLUMN_NAME)));
            }
            connection.commit();
        }

        catch (Exception e){
            handleException("could not list instruments ", e);
        }
        return instruments;

    }

    public boolean activeRental(Integer student, Integer instrument) throws RentalDBException
    {
        boolean ret = false;
        int a = -1;
        try{
            activerental.setInt(1,student);
            activerental.setInt(2,instrument);
            ResultSet result = activerental.executeQuery();
            while(result.next())
            a = result.getInt("count");
            if (a == 1)
                ret = true;

            connection.commit();
        }
        catch (SQLException sqle){
            handleException("could not list active rentals ", sqle);

        }
        return ret;
    }

    public void connectDB() throws SQLException{
        try {
            connection = DriverManager.getConnection("jdbc:postgresql://localhost:5432/sg", "postgres", "12345678");
            connection.setAutoCommit(false);
        }
        catch(SQLException e){

            out.println("Could not connect to DB"+ e);
        }
    }
    private void handleException(String failureMsg, Exception cause) throws RentalDBException {
        String completeFailureMsg = failureMsg;
        try {
            connection.rollback();
        } catch (SQLException rollbackExc) {
            completeFailureMsg = completeFailureMsg +
                    ". Also failed to rollback transaction because of: " + rollbackExc.getMessage();
        }

        if (cause != null) {
            throw new RentalDBException(failureMsg, cause);
        } else {
            throw new RentalDBException(failureMsg);
        }
    }
    private void prepareStatements()throws SQLException{
        activerental = connection.prepareStatement("SELECT COUNT (*) FROM " + RENTAL_TABLE_NAME + " WHERE " + RENTAL_FK_STUDENT_COLUMN_NAME + " = ? AND " + RENTAL_FK_COLUMN_NAME + " = ? AND " + RENTAL_LEASE_PERIOD_COLUMN_NAME + " <> 'terminated'");

        allinstruments = connection.prepareStatement(("SELECT " + INSTRUMENT_PK_COLUMN_NAME + ", " +  INSTRUMENT_PRICE_COLUMN_NAME + ", " +INSTRUMENT_INSTRUMENT_COLUMN_NAME +" FROM " + INSTRUMENT_TABLE_NAME + " WHERE " + INSTRUMENT_IN_STOCK_COLUMN_NAME + " = 'true' ORDER BY " + INSTRUMENT_INSTRUMENT_COLUMN_NAME ));

        instruments = connection.prepareStatement("SELECT i." + INSTRUMENT_PK_COLUMN_NAME + ", i."+ INSTRUMENT_BRAND_COLUMN_NAME + ", i." + INSTRUMENT_PRICE_COLUMN_NAME + " FROM " +
                INSTRUMENT_TABLE_NAME + " i " +
        " WHERE i." + INSTRUMENT_IN_STOCK_COLUMN_NAME +" = 'true' AND i." + INSTRUMENT_INSTRUMENT_COLUMN_NAME + " = ?");

        studentrentals = connection.prepareStatement("SELECT COUNT(*) FROM " + STUDENT_TABLE_NAME + " a INNER JOIN " + RENTAL_TABLE_NAME+ " r ON a." + STUDENT_PK_COLUMN_NAME +
                " = r." + RENTAL_FK_STUDENT_COLUMN_NAME + " WHERE a." + STUDENT_PK_COLUMN_NAME + " = ? AND r." + RENTAL_LEASE_PERIOD_COLUMN_NAME+ " <> 'terminated'");

        intrumentcheck = connection.prepareStatement("SELECT COUNT(*) FROM " + INSTRUMENT_TABLE_NAME + " WHERE " + INSTRUMENT_IN_STOCK_COLUMN_NAME +" = 'true' AND " + INSTRUMENT_PK_COLUMN_NAME +" = ?");

        addrent = connection.prepareStatement("INSERT INTO rental (starting_date,lease_period,wants_home_delivery,instrument_id,student_id) VALUES ( ?, '12_months', 'false', ?, ?)");

        updateinstrument = connection.prepareStatement("UPDATE " + INSTRUMENT_TABLE_NAME + " SET " + INSTRUMENT_IN_STOCK_COLUMN_NAME + " = ? WHERE " + INSTRUMENT_PK_COLUMN_NAME + " = ?");

        terminaterent = connection.prepareStatement("UPDATE " + RENTAL_TABLE_NAME + " SET lease_period = 'terminated' WHERE " + RENTAL_FK_COLUMN_NAME + "= ? AND " + RENTAL_FK_STUDENT_COLUMN_NAME + " = ?");
    }
}
