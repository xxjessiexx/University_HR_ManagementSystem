using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace UNI
{
    public partial class RejectedMedicals : System.Web.UI.Page
    {
        // make sure this name matches your Web.config connection string
        private readonly string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRejectedMedicals();
            }
        }

        protected void btnRefresh_Click(object sender, EventArgs e)
        {
            LoadRejectedMedicals();
        }

        private void LoadRejectedMedicals()
        {
            lblMsg.Text = "";
            try
            {
                using (SqlConnection conn = new SqlConnection(connString))
                using (SqlCommand cmd = new SqlCommand("SELECT * FROM dbo.allRejectedMedicals", conn))
                {
                    conn.Open();
                    using (SqlDataReader rdr = cmd.ExecuteReader())
                    {
                        if (rdr.HasRows)
                        {
                            gvRejectedMedicals.DataSource = rdr;
                            gvRejectedMedicals.DataBind();
                        }
                        else
                        {
                            // clear grid and show friendly message
                            gvRejectedMedicals.DataSource = null;
                            gvRejectedMedicals.DataBind();
                            lblMsg.ForeColor = System.Drawing.Color.DarkOrange;
                            lblMsg.Text = "No rejected medical leaves found (the view returned 0 rows).";
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // show helpful message on page (useful during testing)
                lblMsg.ForeColor = System.Drawing.Color.Red;
                lblMsg.Text = "Error loading rejected medical leaves: " + ex.Message;
            }
        }

        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("~/AdminHome.aspx");

        }
    }
}
