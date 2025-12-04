using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.Configuration;

namespace HR
{
    public partial class MyDeductions : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                gvDeductions.DataSource = null;
                gvDeductions.DataBind();
                errorLabel.Visible = false;
            }
        }

        protected void GetDeductions_Click(object sender, EventArgs e)
        {
            errorLabel.Visible = false;
            gvDeductions.DataSource = null;
            gvDeductions.DataBind();

            if (Session["EmployeeID"] == null)
            {
                errorLabel.Text = "Please log in first.";
                errorLabel.Visible = true;
                return;
            }

            int employeeId = Convert.ToInt32(Session["EmployeeID"]);

            int month;
            if (!Int32.TryParse(txtMonth.Text.Trim(), out month) || month < 1 || month > 12)
            {
                errorLabel.Text = "Please enter a valid month between 1–12.";
                errorLabel.Visible = true;
                return;
            }

            string connStr = WebConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

            try
            {
                using (SqlConnection conn = new SqlConnection(connStr))
                {
                    SqlCommand cmd = new SqlCommand(
                        "SELECT * FROM dbo.Deductions_Attendance(@employee_ID, @month)",
                        conn);

                    cmd.Parameters.AddWithValue("@employee_ID", employeeId);
                    cmd.Parameters.AddWithValue("@month", month);

                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    if (dt.Rows.Count > 0)
                    {
                        gvDeductions.DataSource = dt;
                        gvDeductions.DataBind();
                    }
                    else
                    {
                        errorLabel.Text = "No deductions found for this month.";
                        errorLabel.Visible = true;
                    }
                }
            }
            catch (Exception ex)
            {
                errorLabel.Text = "Error: " + ex.Message;
                errorLabel.Visible = true;
            }
        }
    }
}
