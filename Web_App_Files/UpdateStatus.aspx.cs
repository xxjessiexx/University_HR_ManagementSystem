using System;
using System.Data.SqlClient;

namespace UNI
{
    public partial class UpdateStatus : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e) { }

        protected void btnUpdateStatus_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrWhiteSpace(txtEmpID.Text))
            {
                lblMessage.Text = "Please enter an Employee ID.";
                return;
            }

            int empID = int.Parse(txtEmpID.Text);

            string connStr = "Server=(localdb)\\MSSQLLocalDB;Database=University_HR_ManagementSystem;Trusted_Connection=True;";

            using (SqlConnection conn = new SqlConnection(connStr))
            {
                conn.Open();

                // 1️⃣ Check if employee is on approved leave today
                string checkLeaveQuery = @"
                    SELECT 1
                    FROM Leave l
                    LEFT JOIN Annual_Leave a ON a.request_ID = l.request_ID
                    LEFT JOIN Accidental_Leave ac ON ac.request_ID = l.request_ID
                    LEFT JOIN Medical_Leave m ON m.request_ID = l.request_ID
                    LEFT JOIN Unpaid_Leave u ON u.request_ID = l.request_ID
                    WHERE l.final_approval_status = 'Approved'
                      AND l.start_date <= CAST(GETDATE() AS DATE)
                      AND l.end_date >= CAST(GETDATE() AS DATE)
                      AND (
                             a.emp_ID = @empID
                          OR ac.emp_ID = @empID
                          OR m.emp_ID = @empID
                          OR u.emp_ID = @empID
                      );
                ";

                SqlCommand cmdCheck = new SqlCommand(checkLeaveQuery, conn);
                cmdCheck.Parameters.AddWithValue("@empID", empID);

                object result = cmdCheck.ExecuteScalar();

                string newStatus = (result != null) ? "onleave" : "active";

                // 2️⃣ Update the employee's status
                string updateQuery = @"
                    UPDATE Employee
                    SET employment_status = @status
                    WHERE employee_ID = @empID;
                ";

                SqlCommand cmdUpdate = new SqlCommand(updateQuery, conn);
                cmdUpdate.Parameters.AddWithValue("@status", newStatus);
                cmdUpdate.Parameters.AddWithValue("@empID", empID);

                cmdUpdate.ExecuteNonQuery();
            }

            lblMessage.Text = "Employee status updated successfully!";
        }
    }
}