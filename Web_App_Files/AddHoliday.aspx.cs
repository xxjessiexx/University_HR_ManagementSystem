using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace UNI
{
    public partial class AddHoliday : System.Web.UI.Page
    {
        // Use the connection string name present in Web.config
        private readonly string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                lblMsg.Text = "";
            }
        }

        protected void btnAdd_Click(object sender, EventArgs e)
        {
            lblMsg.ForeColor = System.Drawing.Color.Red;
            lblMsg.Text = "";

            // Basic validation
            string name = txtName.Text.Trim();
            if (string.IsNullOrEmpty(name))
            {
                lblMsg.Text = "Please enter a holiday name.";
                return;
            }

            if (string.IsNullOrWhiteSpace(txtFrom.Text) || string.IsNullOrWhiteSpace(txtTo.Text))
            {
                lblMsg.Text = "Please enter both From Date and To Date.";
                return;
            }

            if (!DateTime.TryParse(txtFrom.Text, out DateTime fromDate))
            {
                lblMsg.Text = "From Date is invalid.";
                return;
            }

            if (!DateTime.TryParse(txtTo.Text, out DateTime toDate))
            {
                lblMsg.Text = "To Date is invalid.";
                return;
            }

            if (fromDate > toDate)
            {
                lblMsg.Text = "From Date must be earlier than or equal to To Date.";
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand("Add_Holiday", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.Add(new SqlParameter("@holiday_name", SqlDbType.VarChar, 50) { Value = name });
                    cmd.Parameters.Add(new SqlParameter("@from_date", SqlDbType.Date) { Value = fromDate.Date });
                    cmd.Parameters.Add(new SqlParameter("@to_date", SqlDbType.Date) { Value = toDate.Date });

                    conn.Open();
                    cmd.ExecuteNonQuery();

                    lblMsg.ForeColor = System.Drawing.Color.Green;
                    lblMsg.Text = "Holiday added successfully.";
                }
            }
            catch (SqlException sqlEx)
            {
                // Stored procedure may PRINT messages; here we show SQL exception if it occurs.
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "SQL Error: " + sqlEx.Message;
            }
            catch (Exception ex)
            {
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Error: " + ex.Message;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminHome.aspx");

        }
    }
}
