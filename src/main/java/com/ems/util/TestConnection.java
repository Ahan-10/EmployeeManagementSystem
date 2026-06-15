package com.ems.util;

import java.sql.Connection;

public class TestConnection {

    public static void main(String[] args) {

        try (Connection con = DBConnection.getConnection()) {

            if (con != null) {

                System.out.println(
                        "Database Connected Successfully!");

            }

        } catch (Exception e) {

            System.out.println(
                    "Connection Failed!");

            e.printStackTrace();
        }
    }
}