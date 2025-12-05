using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace UNI
{
    public partial class EmployeesPerDept : System.Web.UI.Page
    {
        string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadEmployeesPerDept();
            }
        }

        private void LoadEmployeesPerDept()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    SqlCommand cmd = new SqlCommand("SELECT * FROM NoEmployeeDept", conn);
                    conn.Open();

                    gvDept.DataSource = cmd.ExecuteReader();
                    gvDept.DataBind();

                    lblMsg.Text = ""; // clear messages
                }
            }
            catch (Exception ex)
            {
                lblMsg.Text = "Error: " + ex.Message;
                lblMsg.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminHome.aspx");

        }
    }
}
