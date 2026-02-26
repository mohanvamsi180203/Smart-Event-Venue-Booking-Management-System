package com.dao;

import java.sql.*;
import java.time.LocalDateTime;

import com.dto.Organizer;
import com.util.DBConnection;

public class OrganizerDaoImpl implements OrganizerDao {

    @Override
    public boolean registerOrganizer(Organizer organizer) throws Exception {
        String sql = "INSERT INTO organizers (organization_name, business_email, mobile_number, password) VALUES (?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, organizer.getOrganizationName());
            ps.setString(2, organizer.getBusinessEmail());
            ps.setString(3, organizer.getMobileNumber());
            ps.setString(4, organizer.getPassword());

            return ps.executeUpdate() > 0;
        }
    }

    @Override
    public boolean isEmailExists(String email) throws Exception {
        String sql = "SELECT id FROM organizers WHERE business_email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        }
    }

    @Override
    public long getOrganizerIdByEmail(String email) throws Exception {
        String sql = "SELECT id FROM organizers WHERE business_email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getLong("id");
            }
        }
        return 0;
    }

    @Override
    public void saveOtp(long organizerId, String otp) throws Exception {
        String sql = "INSERT INTO email_otps (organizer_id, otp_code, expires_at, is_used) VALUES (?, ?, ?, false)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, organizerId);
            ps.setString(2, otp);
            ps.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now().plusMinutes(5)));
            ps.executeUpdate();
        }
    }

    @Override
    public boolean verifyOtp(String email, String otp) throws Exception {
        String sql = "SELECT o.id FROM organizers o " +
                     "JOIN email_otps e ON o.id = e.organizer_id " +
                     "WHERE o.business_email = ? AND e.otp_code = ? " +
                     "AND e.expires_at > NOW() AND e.is_used = false";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, otp);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                long organizerId = rs.getLong("id");
                markEmailVerified(organizerId);
                markOtpUsed(organizerId);
                return true;
            }
        }
        return false;
    }

    private void markOtpUsed(long organizerId) throws Exception {
        String sql = "UPDATE email_otps SET is_used = true WHERE organizer_id = ? AND is_used = false";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, organizerId);
            ps.executeUpdate();
        }
    }

    @Override
    public void markEmailVerified(long organizerId) throws Exception {
        String sql = "UPDATE organizers SET is_email_verified = 1 WHERE id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setLong(1, organizerId);
            ps.executeUpdate();
        }
    }
}