package visitintramuros.model;

public class HistoricalMarker extends Marker {

    public HistoricalMarker(String identifier, String position,
                            String coordinates, String locationName, String description) {
        super(identifier, position, coordinates, locationName, description);
    }

    @Override
    public void displayInfo() {
        System.out.println("[Historical] " + getLocationName());
        System.out.println("  Coords : " + getCoordinates());
        System.out.println("  Info   : " + getDescription());
    }

    @Override
    public void onSelect() {
        System.out.println("Historical marker selected: " + getLocationName());
    }
}
