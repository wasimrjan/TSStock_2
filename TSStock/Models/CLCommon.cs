namespace TSStock.Models
{
    public static class CLCommon
    {

        public static string SqlIFormat(string vl)
        {
            if (vl == null)
                return "NULL";
            else
                return "'" + vl + "'";
        }

        public static string toDBFormat(string vl)
        {
            if (vl == null)
                return "NULL";
            else
            {
                try
                {
                    DateTime dt = DateTime.Parse(vl);
                    return "'" + dt.ToString("yyyy-MM-dd") + "'";
                }
                catch(Exception ex) 
                {
                    return "NULL";
                }
            }
        }
    }
}
