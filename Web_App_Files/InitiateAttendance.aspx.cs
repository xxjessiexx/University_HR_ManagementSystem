using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace UNI
{
    public partial class InitiateAttendance : System.Web.UI.Page
    {
        private readonly string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack) lblMsg.Text = "";
        }

        protected void btnInitiate_Click(object sender, EventArgs e)
        {
            lblMsg.ForeColor = System.Drawing.Color.Red;
            lblMsg.Text = "";

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand("Initiate_Attendance", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    conn.Open();
                    int rowsAffected = cmd.ExecuteNonQuery(); // SP does INSERTs; ExecuteNonQuery returns number of rows affected (may be 0 if none inserted)

                    // Provide friendly message
                    if (rowsAffected > 0)
                    {
                        lblMsg.ForeColor = System.Drawing.Color.Green;
                        lblMsg.Text = $"Attendance initiated for today. Rows inserted: {rowsAffected}.";
                    }
                    else
                    {
                        lblMsg.ForeColor = System.Drawing.Color.DarkOrange;
                        lblMsg.Text = "No new attendance rows were created (every employee already has a record for today).";
                    }
                }
            }
            catch (SqlException sEx)
            {
                lblMsg.Text = "SQL Error: " + sEx.Message;
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminHome.aspx");

        }
    }
}
