Create PROCEDURE [dbo].[CalcFenBaoHTJE3]
@htbh Varchar(100),
@XMPathKey Varchar(100),
@zxfssj1 datetime,
@zxfssj2 datetime,
@zxtxsj1 datetime,
@zxtxsj2 datetime,
@fkfssj1 datetime,
@fkfssj2 datetime,
@fktxsj1 datetime,
@fktxsj2 datetime,
@fpje Float output,
@zxje Float output,
@fkje Float output,
@FaKuanje Float output,  
@CBHTSK Float output,  
@ShiShouLYBZJ Float output 
As
BEGIN
  Declare @sql Varchar(1000)
  Declare @ZXDateSql Varchar(1000)
  Declare @FKDateSql Varchar(1000)
  Set @ZXDateSql=''
  Set @FKDateSql=''


  IF IsNULL(@zxfssj1,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And �������� >='''+cast(@zxfssj1 as varchar(80))+''''
  End
  IF IsNULL(@zxfssj2,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And �������� <='''+cast(@zxfssj2 as varchar(80))+''''
  End
  IF IsNULL(@zxtxsj1,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And ��д���� >='''+cast(@zxtxsj1 as varchar(80))+'''' 
  End
  IF IsNULL(@zxtxsj2,'')<>'' 
  Begin
    Set @ZXDateSql=@ZXDateSql+' And ��д���� <='''+cast(@zxtxsj2 as varchar(80))+''''
  End

  IF IsNULL(@fkfssj1,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And �������� >='''+cast(@fkfssj1 as varchar(80))+'''' 
  End
  IF IsNULL(@fkfssj2,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And �������� <='''+cast(@fkfssj2 as varchar(80))+'''' 
  End
  IF IsNULL(@fktxsj1,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And ��д���� >='''+cast(@fktxsj1 as varchar(80))+''''   
  End
  IF IsNULL(@fktxsj2,'')<>'' 
  Begin
    Set @FKDateSql=@FKDateSql+' And ��д���� <='''+cast(@fktxsj2 as varchar(80))+'''' 
  End  


  Set @sql='Declare cur1 Cursor Global For Select Sum(��Ӧ���) As FPJE From ��Ʊ�ӱ� where ����=0 And   '
  Set @sql=@sql+'  (��Ӧ��������=''����˹���'' And Exists (Select ��Ӧ���� From ����˹����˱� where ����˹����˱�.��Ӧ����=��Ʊ�ӱ�.��Ʊ��Ӧ���� And ����=0 And ��ͬ���='''+@htbh+''' ) )'
 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @fpje
  Close cur1
  deallocate cur1 
  Set @fpje=ISNULL(@fpje ,0)
 
  Set @Sql='Declare cur1 Cursor Global For Select Sum(��� ) As LjJE From ����˹���ϸ�� where ��ͬ���='''+@HTBH+''' And ����=0  '
  Set @Sql=@Sql+@ZXDateSql
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @zxje
  Close cur1
  deallocate cur1 
  Set @zxje=ISNULL(@zxje ,0) 

  Set @Sql='Declare cur1 Cursor Global For Select Sum( ��� ) As LjJE From �ո������˱� where ��ͬ���='''+@HTBH+''' And ����=0 And  ִ�к�ͬ=''�ְ���ͬ'' ' 
  Set @Sql=@Sql+@FKDateSql 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @fkje
  Close cur1
  deallocate cur1 
  Set @fkje=ISNULL(@fkje ,0)  
 
  Set @Sql='Declare cur1 Cursor Global For Select Sum(������) As LjJE From ������ where ��ͬ���='''+@HTBH+''' And ����=0 ' 
  Set @Sql=@Sql+@ZXDateSql
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @FaKuanje
  Close cur1
  deallocate cur1 
  Set @FaKuanje=ISNULL(@FaKuanje ,0)   

  Set @Sql='Declare cur1 Cursor Global For Select Sum(���) As LjJE From �ո������˱� where ����=0 And ��������=''�տ'' And ִ�к�ͬ=''�а���ͬ'' And �ո�������=''���̿�'' And ��ͬ��� In (Select ��ͬ��� From �а���ͬ�� where XMPathkey='''+@XMPathKey+''' )';
  Set @Sql=@Sql+@FKDateSql 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @CBHTSK
  Close cur1
  deallocate cur1 
  Set @CBHTSK=ISNULL(@CBHTSK ,0)  
  
  Set @Sql='Declare cur1 Cursor Global For Select Sum( Case When ��������=''�տ'' then ��� Else -��� End ) As LjJE From �ո������˱� where ��ͬ���='''+@HTBH+''' And ����=0 And  ִ�к�ͬ=''�ְ���ͬ''  And �ո�������=''��Լ��֤��'' ' 
  Set @Sql=@Sql+@FKDateSql 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @ShiShouLYBZJ
  Close cur1
  deallocate cur1 
  Set @ShiShouLYBZJ=ISNULL(@ShiShouLYBZJ ,0)  


END   
