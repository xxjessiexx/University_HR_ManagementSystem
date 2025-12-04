using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace UNI
{
    public partial class ProcessingUnpaidLeave : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }
        protected void Process(object sender, EventArgs e)
        {
            mssg.Visible = false;
            SqlConnection conn = null;

            try
            {
                // check empty inputs, invalid inputs 
                if (string.IsNullOrWhiteSpace(req_id.Text) ||
                    string.IsNullOrWhiteSpace(upper_id.Text))
                {
                    Showmessage("All fields are required, please fill all.");
                    return;
                }

                if (!int.TryParse(req_id.Text, out int req) ||
                    !int.TryParse(upper_id.Text, out int upper))
                {
                    Showmessage("Please enter valid Id inputs.");
                    return;
                }

                string connStr = System.Web.Configuration.WebConfigurationManager.ConnectionStrings["GUCera"].ToString();
                conn = new SqlConnection(connStr);


                // check current status
                string currentstatus = getleavestat(req, upper, connStr);

                if (currentstatus == "Unknown")
                {
                    Showmessage("No Leave request with the specified data. Please enter a valid request to process");
                    return;
                }

                if (currentstatus != "Pending")
                {
                    Showmessage("Leave request has already been processed.");
                    return;
                }

                SqlCommand upperboardapproveproc = new SqlCommand("Upperboard_approve_unpaids", conn);
                upperboardapproveproc.CommandType = System.Data.CommandType.StoredProcedure;

                int reqid = Int16.Parse(req_id.Text);
                int upperid = Int16.Parse(upper_id.Text);



                upperboardapproveproc.Parameters.Add(new SqlParameter("@request_ID", reqid));
                upperboardapproveproc.Parameters.Add(new SqlParameter("@Upperboard_ID", upperid));



                conn.Open();
                upperboardapproveproc.ExecuteNonQuery();

                string updatedstatus = getleavestat(req, upper, connStr);
                Showmessage("Approval completed. Current status: " + updatedstatus);
            }
            catch (SqlException ex)
            {

                Showmessage("Database error occured. Please refer back to the admin");
            }
            catch (Exception)
            {
                Showmessage("error occurred. please try again.");
            }
            finally
            {
                if (conn != null && conn.State == System.Data.ConnectionState.Open)
                {
                    conn.Close();
                }
            }
        }

        private void Showmessage(string message)
        {
            mssg.Text = message;
            mssg.Visible = true;
        }

        // Helper to get the current status of a leave
        private string getleavestat(int requestId, int upperboardId, string connStr)
        {
            using (SqlConnection conn = new SqlConnection(connStr))
            using (SqlCommand cmd = new SqlCommand(
                "SELECT status FROM Employee_Approve_Leave WHERE leave_ID=@request_ID AND Emp1_ID=@upperboard_ID", conn))
            {
                cmd.Parameters.AddWithValue("@request_ID", requestId);
                cmd.Parameters.AddWithValue("@upperboard_ID", upperboardId);

                conn.Open();
                object result = cmd.ExecuteScalar();

                if (result != null)
                {
                    return result.ToString();
                }
                else
                {
                    return "Unknown";
                }
            }
        }
    }
}