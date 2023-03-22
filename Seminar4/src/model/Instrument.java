package model;

public class Instrument implements InstrumentDTO {
    private Integer id;
    private String brand;
    private String price;

    public Instrument(Integer id, String brand, String price){
        this.id = id;
        this.brand = brand;
        this.price = price;
    }
    public String getBrand(){
        return this.brand;
    }
    public String getPrice(){
        return this.price;
    }
    public Integer getID(){
        return this.id;
    }
}
