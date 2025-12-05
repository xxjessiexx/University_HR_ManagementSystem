using System;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

    namespace UNI
    {
        public partial class RemoveDeductions : System.Web.UI.Page
        {
            string connString = ConfigurationManager.ConnectionStrings["GUCera"].ConnectionString;

            protected void Page_Load(object sender, EventArgs e)
            {

            }

            protected void btnRemove_Click(object sender, EventArgs e)
            {
                lblMsg.Visible = false;   // hide old message

                try
                {
                    using (SqlConnection conn = new SqlConnection(connString))
                    {
                        SqlCommand cmd = new SqlCommand("Remove_Deductions", conn);
                        cmd.CommandType = CommandType.StoredProcedure;

                        conn.Open();
                        int rows = cmd.ExecuteNonQuery();   // count affected rows

                        if (rows > 0)
                        {
                            lblMsg.Text = $"{rows} deduction record(s) removed successfully for resigned employees.";
                            lblMsg.ForeColor = System.Drawing.Color.Green;
                        }
                        else
                        {
                            lblMsg.Text = "No deductions were removed. (No resigned employees had deductions.)";
                            lblMsg.ForeColor = System.Drawing.Color.Orange;
                        }
                    }
                }
                catch (Exception ex)
                {
                    lblMsg.Text = "Error: " + ex.Message;
                    lblMsg.ForeColor = System.Drawing.Color.Red;
                }

                lblMsg.Visible = true; // finally show the label
            }

            protected void btnBack_Click(object sender, EventArgs e)
            {
                Response.Redirect("~/AdminHome.aspx");
            }
        }
    }
