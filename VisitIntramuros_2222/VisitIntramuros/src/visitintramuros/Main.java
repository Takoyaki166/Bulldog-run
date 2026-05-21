package visitintramuros;

import visitintramuros.view.HomeScreen;

import javax.swing.*;

public class Main {

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            JFrame frame = new JFrame("VisitIntramuros — Interactive Map Application");
            frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
            frame.setSize(1100, 700);
            frame.setMinimumSize(new java.awt.Dimension(900, 600));
            frame.setLocationRelativeTo(null);

            frame.setContentPane(new HomeScreen(frame));
            frame.setVisible(true);
        });
    }
}
