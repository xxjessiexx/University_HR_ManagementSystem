using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace UNI
{
    public partial class UpdateAttendance : System.Web.UI.Page
    {
        // Make sure this matches the connection string name in Web.config
        private readonly string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMsg.Text = "";
            }
        }

        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            lblMsg.ForeColor = System.Drawing.Color.Red;
            lblMsg.Text = "";

            // Validate employee id
            if (string.IsNullOrWhiteSpace(txtEmpID.Text) || !int.TryParse(txtEmpID.Text.Trim(), out int empId))
            {
                lblMsg.Text = "Please enter a valid numeric Employee ID.";
                return;
            }

            // Parse times (allow empty)
            bool hasCheckIn = TimeSpan.TryParse(txtCheckIn.Text.Trim(), out TimeSpan checkInTs);
            bool hasCheckOut = TimeSpan.TryParse(txtCheckOut.Text.Trim(), out TimeSpan checkOutTs);

            // If textboxes empty, treat as NULL
            object checkInParam = DBNull.Value;
            object checkOutParam = DBNull.Value;

            if (!string.IsNullOrWhiteSpace(txtCheckIn.Text))
            {
                if (!hasCheckIn)
                {
                    lblMsg.Text = "Check-in time format is invalid. Use HH:mm or HH:mm:ss.";
                    return;
                }
                // SQL TIME maps to TimeSpan; we pass as Time
                checkInParam = new TimeSpan(checkInTs.Hours, checkInTs.Minutes, checkInTs.Seconds);
            }

            if (!string.IsNullOrWhiteSpace(txtCheckOut.Text))
            {
                if (!hasCheckOut)
                {
                    lblMsg.Text = "Check-out time format is invalid. Use HH:mm or HH:mm:ss.";
                    return;
                }
                checkOutParam = new TimeSpan(checkOutTs.Hours, checkOutTs.Minutes, checkOutTs.Seconds);
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand("Update_Attendance", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@Employee_id", SqlDbType.Int) { Value = empId });

                    // stored proc signature: @check_in_time TIME = NULL, @check_out_time TIME = NULL
                    var pIn = new SqlParameter("@check_in_time", SqlDbType.Time);
                    pIn.IsNullable = true;
                    pIn.Value = (checkInParam == DBNull.Value) ? (object)DBNull.Value : checkInParam;
                    cmd.Parameters.Add(pIn);

                    var pOut = new SqlParameter("@check_out_time", SqlDbType.Time);
                    pOut.IsNullable = true;
                    pOut.Value = (checkOutParam == DBNull.Value) ? (object)DBNull.Value : checkOutParam;
                    cmd.Parameters.Add(pOut);

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMsg.ForeColor = System.Drawing.Color.Green;
                    lblMsg.Text = "Attendance updated for employee ID " + empId + ".";
                }
            }
            catch (SqlException sqlEx)
            {
                // SQL errors (e.g. FK, SP error) shown to help debugging during dev
                lblMsg.Text = "SQL Error: " + sqlEx.Message;
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
