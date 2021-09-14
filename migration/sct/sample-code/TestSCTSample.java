/**
 * This is a SAMPLE code file for demonstrating the
 * working of the SCT code analysis. No attempt has
 * been made to address any syntatic/semantic issues
 * in this sample code.
 **/

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;

public class TestSCTSample {

    public static void test1(String[] args, int actor_id) {

        String cs = "jdbc:mysql://localhost:3306/testdb?useSSL=false";
        String user = "testuser";
        String password = "test623";

        try (Connection con = DriverManager.getConnection(cs, user, password);
                Statement st = con.createStatement()) {

            for (int i = 1; i <= 5000; i++) {

                String sql = "INSERT INTO actor VALUES(" + actor_id +","+ "\"fname\""+ ","+ "\"lname\""+ ")";
                st.executeUpdate(sql);
            }

        } catch (SQLException ex) {

            Logger lgr = Logger.getLogger(TestSCTSample.class.getName());
            lgr.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }

    public static void test2(String[] args) {

        String cs = "jdbc:mysql://localhost:3306/testdb?useSSL=false";
        String user = "testuser";
        String password = "test623";

        String sql = "INSERT INTO Testing(Id) VALUES(?)";

        try (Connection con = DriverManager.getConnection(cs, user, password);
                PreparedStatement pst = con.prepareStatement(sql)) {

            for (int i = 1; i <= 5000; i++) {

                pst.setInt(1, i * 2);
                pst.executeUpdate();
            }

        } catch (SQLException ex) {

            Logger lgr = Logger.getLogger(JdbcPreparedTesting.class.getName());
            lgr.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }

    public static void test3(String[] args) {

        String url = "jdbc:mysql://localhost:3306/testdb?useSSL=false";
        String user = "testuser";
        String password = "test623";
        
        String query = "SELECT * FROM actor";

        try (Connection con = DriverManager.getConnection(url, user, password);
                PreparedStatement pst = con.prepareStatement(query);
                ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {

                System.out.print(rs.getInt(1));
                System.out.print(": ");
                System.out.println(rs.getString(2));
            }

        } catch (SQLException ex) {

            Logger lgr = Logger.getLogger(JdbcRetrieve.class.getName());
            lgr.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }

    public static void test4(String[] args) throws SQLException {

        String cs = "jdbc:mysql://localhost:3306/"
                + "testdb?allowMultiQueries=true&useSSL=false";
        String user = "testuser";
        String password = "test623";

        String query = "SELECT Id, Name FROM actor WHERE Id=1;"
                + "SELECT Id, Name FROM actor WHERE Id=2;"
                + "SELECT Id, Name FROM actor WHERE Id=3";

        try (Connection con = DriverManager.getConnection(cs, user, password);
                PreparedStatement pst = con.prepareStatement(query);) {

            boolean isResult = pst.execute();

            do {
                try (ResultSet rs = pst.getResultSet()) {

                    while (rs.next()) {

                        System.out.print(rs.getInt(1));
                        System.out.print(": ");
                        System.out.println(rs.getString(2));
                    }

                    isResult = pst.getMoreResults();
                }

            } while (isResult);
        }
    }

    public static void test5(String[] args, int actor_id) {

        String cs = "jdbc:mysql://localhost:3306/testdb?useSSL=false";
        String user = "testuser";
        String password = "test623";

        String query = "SELECT last_name, first_name From actor "
                + " WHERE id=actor_id";

        try (Connection con = DriverManager.getConnection(cs, user, password);
                PreparedStatement pst = con.prepareStatement(query);
                ResultSet rs = pst.executeQuery()) {

            ResultSetMetaData meta = rs.getMetaData();

            String colname1 = meta.getColumnName(1);
            String colname2 = meta.getColumnName(2);

            String header = String.format("%-21s%s", colname1, colname2);
            System.out.println(header);

            while (rs.next()) {

                String row = String.format("%-21s", rs.getString(1));
                System.out.print(row);
                System.out.println(rs.getString(2));
            }
        } catch (SQLException ex) {
            
            Logger lgr = Logger.getLogger(JdbcColumnHeaders.class.getName());
            lgr.log(Level.SEVERE, ex.getMessage(), ex);
        }
    }
}