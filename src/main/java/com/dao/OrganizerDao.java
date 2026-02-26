package com.dao;

import com.dto.Organizer;

public interface OrganizerDao {

    boolean registerOrganizer(Organizer organizer) throws Exception;

    boolean isEmailExists(String email) throws Exception;

    long getOrganizerIdByEmail(String email) throws Exception;

    void saveOtp(long organizerId, String otp) throws Exception;

    boolean verifyOtp(String email, String otp) throws Exception;

    void markEmailVerified(long organizerId) throws Exception;
}