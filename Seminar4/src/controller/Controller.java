package controller;

import java.util.*;
import static java.lang.System.out;
import integration.*;
import model.InstrumentDTO;

public class Controller {
    private final RentalDAO rentalDb;

    public Controller() throws RentalDBException {
        rentalDb = new RentalDAO();
    }
    public List<? extends InstrumentDTO> instruments(String type)throws Exception {

        try{
            return rentalDb.instruments(type);
        }
        catch(Exception e){
            throw new Exception("Unable to list instruments",e);
        }
    }
    public List<? extends InstrumentDTO> allinstruments()throws Exception {

        try{
            return rentalDb.allInstruments();
        }
        catch(Exception e){
            throw new Exception("Unable to list instruments",e);
        }
    }

    public void terminate(Integer student, Integer instrument)throws RentalDBException
    {
        if(student == null || instrument == null)
            throw new RentalDBException("wrong input");
        try{
            if(rentalDb.activeRental(student,instrument)){
            rentalDb.terminate(student,instrument);
            out.println("Successfully terminated rent on instrument with id: " + instrument + " for student with id: " + student);}
            else
                out.println("No active rental for student " + student +" for instrument " + instrument);
        } catch(Exception e){
            out.println("Unable to terminate rental " + e);
        }

    }
    public void rent(Integer student, Integer instrument)throws RentalDBException{
        if(student == null || instrument == null)
            throw new RentalDBException("wrong input");
        int a = rentalDb.checkstudentrentals(student);
        if(a >= 2) {
            out.println("To many rentals!");
        }else {
            a = rentalDb.checkinstrument(instrument);
            if (a < 1)
                out.println("Instrument unavailable");
            else{
                rentalDb.rent(student,instrument);
                out.println("Successfully rented instrument with id: " + instrument + " to student with id: " + student);
            }
        }
    }
}
